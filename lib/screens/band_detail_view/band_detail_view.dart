import 'package:cached_network_image/cached_network_image.dart';
import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/band.dart';
import '../../models/band_with_events.dart';
import '../../models/event.dart';
import '../../models/theme.dart';
import '../../providers/bands_with_events.dart';
import '../../utils/logging.dart';
import '../../widgets/dense_event_list.dart';
import '../../widgets/event_date/event_date.dart';
import '../../widgets/event_playing_indicator/event_playing_indicator.dart';
import '../../widgets/event_stage.dart';
import '../../widgets/event_toggle/event_toggle.dart';
import '../../widgets/scaffold.dart';
import 'band_detail_view.i18n.dart';

// TODO(SF) STYLE NOW improve
class BandDetailView extends HookWidget {
  const BandDetailView(this.bandName);

  final String bandName;

  static void openFor(BuildContext context, String bandName) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => BandDetailView(bandName),
        fullscreenDialog: true,
      ));

  FestivalTheme get _festivalTheme => dimeGet<FestivalTheme>();
  Logger get _log => const Logger('BandDetailView');

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
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Text('${title.i18n}:', style: theme.textTheme.subtitle2),
            ),
            Flexible(flex: 7, fit: FlexFit.tight, child: Text(value)),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(_getDescription(locale, band)),
              ),
              _buildDetailRow(
                theme,
                'Origin',
                _isValueSet(band.origin)
                    ? _buildFlag(band.origin)
                    : _fallbackText,
              ),
              if (_isValueSet(band.style))
                _buildDetailRow(theme, 'Style', band.style),
              if (_isValueSet(band.roots))
                _buildDetailRow(theme, 'Roots', band.roots),
              const SizedBox(
                height: 10,
              ),
              if (_isValueSet(band.spotify))
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: _festivalTheme.primaryButton(
                    label: 'Play on Spotify'.i18n,
                    onPressed: () {
                      launch(band.spotify);
                    },
                  ),
                ),
            ],
          ),
        ),
        if (_isValueSet(band.image))
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: CachedNetworkImage(
              imageUrl: band.image,
            ),
          ),
      ];

  Widget _buildBandLogo(String logo) => Container(
        color: Colors.black,
        child: CachedNetworkImage(
          imageUrl: logo,
        ),
        height: 100,
      );

  Widget get _fallbackInfo => Container(
        padding:
            const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
        alignment: Alignment.center,
        child: Text(_fallbackText),
      );

  Widget _buildSingleEventEntry(Event event) => Padding(
        padding: const EdgeInsets.only(right: 10, top: 9, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            EventToggle(event),
            const SizedBox(width: 24),
            EventDate(
              start: event.start,
              end: event.end,
              showWeekDay: true,
            ),
            EventPlayingIndicator(isPlaying: event.isPlaying(DateTime.now())),
            EventStage(event.stage),
          ],
        ),
      );

  Widget _buildMultiEventEntry(ImmortalList<Event> events) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 7),
        child: DenseEventList(
          events: events,
          currentTime: DateTime.now(),
        ),
      );

  Widget _buildEvents(ImmortalList<Event> events) => events.isEmpty
      ? const SizedBox(height: 5)
      : SafeArea(
          top: false,
          bottom: false,
          minimum: const EdgeInsets.symmetric(horizontal: 10),
          child: events.length == 1
              ? _buildSingleEventEntry(events.first.value)
              : _buildMultiEventEntry(events));

  Widget _buildBandView(BuildContext context, BandWithEvents bandWithEvents) {
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final band = bandWithEvents.band;
    return AppScaffold(
      isDialog: true,
      title: 'Band Details'.i18n,
      body: Container(
        alignment: Alignment.topCenter,
        child: ListView(
          children: <Widget>[
            if (band.isPresent && _isValueSet(band.value.logo))
              _buildBandLogo(band.value.logo),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text(
                bandName.toUpperCase(),
                style: theme.textTheme.headline3,
                textAlign: TextAlign.center,
              ),
            ),
            _buildEvents(bandWithEvents.events),
            ...band
                .map<List<Widget>>((b) => _buildDetails(theme, locale, b))
                .orElse(
              <Widget>[_fallbackInfo],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bandProvider =
        useProvider(dimeGet<BandWithEventsProvider>()(bandName));
    return bandProvider.when(
      data: (band) => _buildBandView(context, band),
      // TODO(SF) THEME NOW
      // TODO(SF) THEME NOW move inside scaffold? or navigate back with error?
      loading: () => const Center(child: Text('Loading!')),
      error: (error, trace) {
        _log.error('Error retrieving data for band $bandName', error, trace);
        return Center(
          child: Text('Error! $error ${trace.toString()}'),
        );
      },
    );
  }
}
