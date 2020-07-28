import 'package:cached_network_image/cached_network_image.dart';
import 'package:dime/dime.dart';
import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/band.dart';
import '../../models/band_key.dart';
import '../../models/band_with_events.dart';
import '../../models/event.dart';
import '../../models/festival_config.dart';
import '../../models/theme.dart';
import '../../providers/bands_with_events.dart';
import '../../providers/festival_scope.dart';
import '../../utils/logging.dart';
import '../../widgets/bands/band_cancelled/band_cancelled.dart';
import '../../widgets/events/dense_event_list.dart';
import '../../widgets/events/event_date/event_date.dart';
import '../../widgets/events/event_playing_indicator/event_playing_indicator.dart';
import '../../widgets/events/event_stage.dart';
import '../../widgets/events/event_toggle/event_toggle.dart';
import '../../widgets/history/history_wrapper.dart';
import '../../widgets/messages/error_screen/error_screen.dart';
import '../../widgets/messages/loading_screen/loading_screen.dart';
import '../../widgets/scaffold.dart';
import '../../widgets/visibility_builder.dart';
import 'band_detail_view.i18n.dart';

// TODO(SF) FEATURE periodic rebuild for is playing indicator?
class BandDetailView extends HookWidget {
  const BandDetailView(this.bandName);

  final String bandName;

  static void openFor(String bandName, {BuildContext context}) {
    final navigatorKey = dimeGet<GlobalKey<NavigatorState>>();
    final festivalScope = context != null
        ? DimeFlutter.get<FestivalScope>(context)
        : _config.currentFestivalScope;
    navigatorKey.currentState.push(MaterialPageRoute(
      builder: (_) => HistoryWrapper(
        festivalScope: festivalScope,
        child: BandDetailView(bandName),
      ),
      fullscreenDialog: true,
    ));
  }

  static FestivalConfig get _config => dimeGet<FestivalConfig>();
  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  Logger get _log => const Logger(module: 'BandDetailView');

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

  Widget _buildDetails(
    ThemeData theme,
    Locale locale,
    Band band,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(_getDescription(locale, band)),
          ),
          _buildDetailRow(
            theme,
            'Origin',
            _isValueSet(band.origin) ? _buildFlag(band.origin) : _fallbackText,
          ),
          VisibilityBuilder(
            visible: _isValueSet(band.style),
            builder: (_) => _buildDetailRow(theme, 'Style', band.style),
          ),
          VisibilityBuilder(
            visible: _isValueSet(band.roots),
            builder: (_) => _buildDetailRow(theme, 'Roots', band.roots),
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
            visible: _isValueSet(band.spotify),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _theme.primaryButton(
                label: 'Play on Spotify'.i18n,
                onPressed: () {
                  launch(band.spotify);
                },
              ),
            ),
          ),
        ],
      );

  Widget _buildImagePlaceholder(ThemeData theme, ImageData imageData) => Stack(
        children: <Widget>[
          if (imageData.hasHash) BlurHash(hash: imageData.hash),
          Shimmer.fromColors(
            baseColor: Colors.transparent,
            highlightColor: _theme.shimmerColor,
            child: Container(color: theme.scaffoldBackgroundColor),
            loop: 1,
          ),
        ],
      );

  Widget _buildImage(ThemeData theme, String imgUrl, [ImageData imgData]) =>
      CachedNetworkImage(
        imageUrl: imgUrl,
        placeholder: imgData != null
            ? (_, __) => _buildImagePlaceholder(theme, imgData)
            : null,
        placeholderFadeInDuration: const Duration(milliseconds: 200),
      );

  Widget _buildBandLogo(ThemeData theme, String imgUrl, ImageData imgData) =>
      Container(
        color: Colors.black,
        height: 100,
        alignment: Alignment.center,
        child: _buildImage(theme, imgUrl, imgData),
      );

  Widget _buildBandImage(ThemeData theme, String imgUrl, ImageData imgData) =>
      imgData.hasRatio
          ? AspectRatio(
              aspectRatio: imgData.ratio,
              child: _buildImage(theme, imgUrl, imgData),
            )
          : _buildImage(theme, imgUrl);

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

  Widget _buildEvents(BandWithEvents bandWithEvents) =>
      bandWithEvents.events.isEmpty
          ? Container(
              padding: const EdgeInsets.only(top: 10, bottom: 2),
              alignment: Alignment.center,
              child: BandCancelled(bandWithEvents),
            )
          : SafeArea(
              top: false,
              bottom: false,
              minimum: const EdgeInsets.symmetric(horizontal: 10),
              child: bandWithEvents.events.length == 1
                  ? _buildSingleEventEntry(bandWithEvents.events.first.value)
                  : _buildMultiEventEntry(bandWithEvents.events));

  Widget _buildBandView(BuildContext context, BandWithEvents bandWithEvents) {
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final band = bandWithEvents.band;
    return Container(
      alignment: Alignment.topCenter,
      child: ListView(
        children: <Widget>[
          VisibilityBuilder(
            visible: band.isPresent && _isValueSet(band.value.logo),
            builder: (_) =>
                _buildBandLogo(theme, band.value.logo, band.value.logoData),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Text(
              bandName.toUpperCase(),
              style: theme.textTheme.headline3,
              textAlign: TextAlign.center,
            ),
          ),
          _buildEvents(bandWithEvents),
          band
              .map<Widget>((b) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: _buildDetails(theme, locale, b)))
              .orElse(_fallbackInfo),
          VisibilityBuilder(
            visible: band.isPresent && _isValueSet(band.value.image),
            builder: (_) => Padding(
              padding: const EdgeInsets.only(top: 5),
              child: _buildBandImage(
                  theme, band.value.image, band.value.imageData),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final festivalScope = DimeFlutter.get<FestivalScope>(context);
    final bandProvider = useProvider(dimeGet<BandWithEventsProvider>()(BandKey(
      festivalId: festivalScope.festivalId,
      bandName: bandName,
    )));
    return AppScaffold(
      isDialog: true,
      title: 'Band Details'.i18n + festivalScope.titleSuffix,
      body: bandProvider.when(
        data: (band) => _buildBandView(context, band),
        loading: () => LoadingScreen('Loading band data.'.i18n),
        error: (error, trace) {
          _log.error('Error retrieving data for band $bandName', error, trace);
          return ErrorScreen('There was an error retrieving band data.'.i18n);
        },
      ),
    );
  }
}
