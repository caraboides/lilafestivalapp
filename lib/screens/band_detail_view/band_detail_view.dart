import 'package:cached_network_image/cached_network_image.dart';
import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:optional/optional.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/band.dart';
import '../../models/enhanced_event.dart';
import '../../models/event.dart';
import '../../models/theme.dart';
import '../../providers/bands.dart';
import '../../widgets/event_date/event_date.dart';
import '../../widgets/event_stage.dart';
import '../../widgets/event_toggle/event_toggle.dart';
import 'band_detail_view.i18n.dart';

// TODO(SF) improve
class BandDetailView extends StatelessWidget {
  const BandDetailView(this.enhancedEvent);

  final EnhancedEvent enhancedEvent;

  static void openFor(BuildContext context, EnhancedEvent event) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => BandDetailView(event),
        fullscreenDialog: true,
      ));

  Event get _event => enhancedEvent.event;

  FestivalTheme get _festivalTheme => dimeGet<FestivalTheme>();

  String _buildFlag(String country) =>
      String.fromCharCodes(country.runes.map((code) => code + 127397));

  static bool _isValueSet(String value) => value?.isNotEmpty ?? false;

  String get _fallbackText => 'Sorry, no info'.i18n;

  String _getDescription(Locale locale, Band band) {
    if (locale.languageCode == 'de' && _isValueSet(band.textDe)) {
      return band.textDe;
    }
    if (_isValueSet(band.textEn)) {
      return band.textEn;
    }
    return _fallbackText;
  }

  Widget _buildDetailRow(ThemeData theme, String title, String value) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 75,
              child: Text(
                '${title.i18n}:',
                style: theme.textTheme.subtitle2,
              ),
            ),
            Text(value),
          ],
        ),
      );

  List<Widget> _buildDetails(
    ThemeData theme,
    Locale locale,
    Band band,
  ) =>
      <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 15),
          child: Text(_getDescription(locale, band)),
        ),
        if (_isValueSet(band.origin))
          _buildDetailRow(theme, 'Origin', _buildFlag(band.origin)),
        if (_isValueSet(band.style))
          _buildDetailRow(theme, 'Style', band.style),
        if (_isValueSet(band.roots))
          _buildDetailRow(theme, 'Roots', band.roots),
        if (_isValueSet(band.spotify))
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 15),
            child: _festivalTheme.primaryButton(
              label: 'Play on Spotify'.i18n,
              onPressed: () {
                launch(band.spotify);
              },
            ),
          ),
        if (_isValueSet(band.image))
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: CachedNetworkImage(
              imageUrl: band.image,
            ),
          ),
      ];

  Widget _buildEventRow() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          EventToggle(
            isActive: enhancedEvent.isScheduled,
            onToggle: enhancedEvent.toggleEvent,
          ),
          EventDate(
            start: _event.start,
            end: _event.end,
            showWeekDay: true,
          ),
          EventStage(_event.stage),
        ],
      );

  Widget _buildBandView(BuildContext context, Optional<Band> band) {
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: _festivalTheme.appBar('Band Details'.i18n),
      body: Container(
        alignment: Alignment.topCenter,
        child: ListView(
          children: <Widget>[
            band
                .map<Widget>((d) => _isValueSet(d.logo)
                    ? Container(
                        color: Colors.black,
                        child: CachedNetworkImage(
                          imageUrl: d.logo,
                        ),
                        height: 100,
                      )
                    : Container())
                .orElse(Container()),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text(
                // TODO(SF) use family provider and display key here
                _event.bandName.toUpperCase(),
                style: theme.textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 20, top: 5),
              child: _buildEventRow(),
            ),
            ...band
                .map<List<Widget>>((d) => _buildDetails(theme, locale, d))
                .orElse(<Widget>[
              Container(
                padding: const EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 20),
                alignment: Alignment.center,
                child: Text(_fallbackText),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Consumer((context, read) {
        // TODO(SF) use family provider and only read single band
        // TODO(SF) listen to schedule here as well to get update on schedule
        // change
        // TODO(SF) highlight event when currently playing?
        final bandsProvider = read(dimeGet<BandsProvider>());
        return bandsProvider.when(
          data: (bands) => _buildBandView(context, bands.get(_event.bandName)),
          // TODO(SF)
          loading: () => Center(child: Text('Loading!')),
          error: (e, trace) => Center(
            child: Text('Error! $e ${trace.toString()}'),
          ),
        );
      });
}
