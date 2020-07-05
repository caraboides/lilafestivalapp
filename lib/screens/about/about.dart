import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';

import '../../models/festival_config.dart';
import '../../models/global_config.dart';
import '../../models/reference.dart';
import '../../models/theme.dart';
import '../../utils/i18n.dart';
import '../menu/menu.dart';
import 'about.i18n.dart';

class About extends StatelessWidget {
  const About();

  static Widget builder(BuildContext context) => About();

  FestivalTheme get theme => dimeGet<FestivalTheme>();

  Widget _buildLink(
    String url, {
    String label,
    bool shrink = false,
  }) =>
      FlatButton(
        textColor: theme.theme.accentColor,
        child: Text(label ?? url),
        onPressed: () => launch(url),
        materialTapTargetSize: shrink
            ? MaterialTapTargetSize.shrinkWrap
            : MaterialTapTargetSize.padded,
      );

  List<Widget> _buildLinks(
    ImmortalList<Link> links, {
    bool shrink = false,
  }) =>
      links
          .map((link) => _buildLink(
                link.url,
                label: link.label,
                shrink: shrink,
              ))
          .toMutableList();

  Widget _buildReference(
    String label,
    ImmortalList<Link> links, {
    bool useHeartIcon = false,
  }) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          useHeartIcon ? theme.heartIcon : theme.starIcon,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(label),
              ),
              ..._buildLinks(links, shrink: true),
            ],
          )
        ],
      );

  List<Widget> _buildReferences(
    ImmortalList<Reference> references, {
    String Function(String label) labelGenerator,
    bool useHeartIcon = false,
  }) =>
      references
          .map(
            (reference) => _buildReference(
              labelGenerator != null
                  ? labelGenerator(reference.label)
                  : reference.label,
              reference.links,
              useHeartIcon: useHeartIcon,
            ),
          )
          .toMutableList();

  List<Widget> _buildMessage(String label, ImmortalList<Link> links) =>
      <Widget>[
        Text(label),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _buildLinks(links),
        ),
      ];

  List<Widget> _buildMessages(ImmortalList<Reference> messages) => messages
      .map((message) => _buildMessage(message.label, message.links))
      .flattenIterables<Widget>()
      .toMutableList();

  @override
  Widget build(BuildContext context) {
    final config = dimeGet<FestivalConfig>();
    final globalConfig = dimeGet<GlobalConfig>();
    return Theme(
      data: theme.aboutTheme,
      child: Scaffold(
        // TODO(SF) create scaffold class?
        drawer: const Menu(),
        appBar: theme.appBar('About'.i18n),
        backgroundColor: theme.aboutBackgroundColor,
        body: ListView(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
          children: <Widget>[
            ..._buildMessages(
              ImmortalList([
                Reference(
                  label: 'This is an unofficial app for the {festival}:'
                      .i18n
                      .fill({'festival': config.festivalFullName}),
                  links: ImmortalList([
                    Link(url: config.festivalUrl),
                  ]),
                ),
                Reference(
                  label: 'Source code can be found under'.i18n,
                  links: ImmortalList([
                    Link(url: globalConfig.repositoryUrl),
                  ]),
                ),
              ]),
            ),
            theme.divider,
            SizedBox(height: 5), // TODO(SF) move to theme?
            Text('Created by Projekt LilaHerz'.i18n),
            SizedBox(height: 10),
            ..._buildReferences(
              globalConfig.creators,
              useHeartIcon: true,
            ),
            theme.divider,
            SizedBox(height: 5),
            ..._buildReferences(
              globalConfig.references,
              labelGenerator: (label) => label.i18n,
            ),
            ..._buildReferences(
              config.fontReferences,
              labelGenerator: (label) =>
                  'Font "{font}" by:'.i18n.fill({'font': label}),
            ),
            theme.divider,
            SizedBox(height: 5),
            ..._buildMessages(
              config.aboutMessages,
            ),
            theme.divider,
            SizedBox(height: 5),
            theme.primaryButton(
              label: MaterialLocalizations.of(context).viewLicensesButtonLabel,
              onPressed: () async {
                final packageInfo = await PackageInfo.fromPlatform();
                showLicensePage(
                  context: context,
                  applicationName: '{festivalName} App'
                      .i18n
                      .fill({'festivalName': config.festivalName}),
                  applicationVersion: packageInfo.version,
                  applicationLegalese:
                      'Copyright 2019 - 2020 Projekt LilaHerz 💜'.i18n,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
