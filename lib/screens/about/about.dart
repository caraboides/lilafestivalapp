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
import '../../widgets/scaffold.dart';
import 'about.i18n.dart';

class About extends StatelessWidget {
  const About();

  static Widget builder(BuildContext context) => About();
  static String title() => 'About'.i18n;

  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  FestivalConfig get _config => dimeGet<FestivalConfig>();
  GlobalConfig get _globalConfig => dimeGet<GlobalConfig>();

  Widget get _divider => Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Divider(height: 1),
      );

  Widget _buildImageLink(Link link) => GestureDetector(
        child: Image.asset(link.imageAssetPath),
        onTap: () => launch(link.url),
      );

  Widget _buildButtonLink(
    Link link, {
    bool shrink = false,
  }) =>
      FlatButton(
        child: Text(link.label ?? link.url),
        onPressed: () => launch(link.url),
        materialTapTargetSize: shrink
            ? MaterialTapTargetSize.shrinkWrap
            : MaterialTapTargetSize.padded,
      );

  Widget _buildLink(
    Link link, {
    bool shrink = false,
  }) =>
      link.imageAssetPath != null
          ? _buildImageLink(link)
          : _buildButtonLink(link, shrink: shrink);

  List<Widget> _buildLinks(
    ImmortalList<Link> links, {
    bool shrink = false,
  }) =>
      links.map((link) => _buildLink(link, shrink: shrink)).toMutableList();

  Widget _buildReference(
    String label,
    ImmortalList<Link> links, {
    Icon icon,
  }) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          icon ?? Icon(_theme.aboutIcon),
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
    Icon icon,
  }) =>
      references
          .map(
            (reference) => _buildReference(
              labelGenerator != null
                  ? labelGenerator(reference.label)
                  : reference.label,
              reference.links,
              icon: icon,
            ),
          )
          .toMutableList();

  List<Widget> _buildMessage(String label, ImmortalList<Link> links) =>
      <Widget>[
        if (label != null) Text(label),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _buildLinks(links),
        ),
      ];

  List<Widget> _buildMessages(ImmortalList<Reference> messages) => messages
      .map((message) => _buildMessage(message.label, message.links))
      .flattenIterables<Widget>()
      .toMutableList();

  void _showLicenses(BuildContext context) async {
    final packageInfo = await PackageInfo.fromPlatform();
    showLicensePage(
      context: context,
      applicationName: '{festivalName} App'
          .i18n
          .fill({'festivalName': _config.festivalName}),
      applicationVersion: packageInfo.version,
      applicationLegalese: 'Copyright 2019 - 2020 Projekt LilaHerz 💜'.i18n,
    );
  }

  @override
  Widget build(BuildContext _) => Theme(
        data: _theme.aboutTheme,
        child: Builder(
          builder: (context) => AppScaffold(
            title: 'About'.i18n,
            body: ListView(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
              children: <Widget>[
                ..._buildMessages(
                  ImmortalList([
                    Reference(
                      label: 'This is an unofficial app for the {festival}:'
                          .i18n
                          .fill({'festival': _config.festivalFullName}),
                      links: ImmortalList([
                        Link(url: _config.festivalUrl),
                      ]),
                    ),
                    Reference(
                      label: 'Source code can be found under'.i18n,
                      links: ImmortalList([
                        Link(url: _globalConfig.repositoryUrl),
                      ]),
                    ),
                  ]),
                ),
                _divider,
                SizedBox(height: 5),
                Text('Created by Projekt LilaHerz'.i18n),
                SizedBox(height: 10),
                ..._buildReferences(
                  _globalConfig.creators,
                  icon: _theme.heartIcon,
                ),
                _divider,
                SizedBox(height: 5),
                ..._buildReferences(
                  _globalConfig.references,
                  labelGenerator: (label) => label.i18n,
                ),
                ..._buildReferences(
                  _config.fontReferences,
                  labelGenerator: (label) =>
                      'Font "{font}" by:'.i18n.fill({'font': label}),
                ),
                _divider,
                SizedBox(height: 5),
                ..._buildMessages(
                  _config.aboutMessages,
                ),
                _divider,
                SizedBox(height: 5),
                _theme.primaryButton(
                  label:
                      MaterialLocalizations.of(context).viewLicensesButtonLabel,
                  onPressed: () => _showLicenses(context),
                ),
              ],
            ),
          ),
        ),
      );
}
