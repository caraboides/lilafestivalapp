import 'package:cached_network_image/cached_network_image.dart';
import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';
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
import '../../utils/date.dart';
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
import '../../widgets/optional_builder.dart';
import '../../widgets/scaffold.dart';
import 'band_detail_view.i18n.dart';

// TODO(SF): FEATURE periodic rebuild for is playing indicator?
class BandDetailView extends HookConsumerWidget {
  const BandDetailView(this.bandName);

  final String bandName;

  static void openFor(String bandName, {BuildContext? context}) {
    final navigatorKey = dimeGet<GlobalKey<NavigatorState>>();
    final festivalScope =
        context != null
            ? DimeFlutter.get<FestivalScope>(context)
            : _config.currentFestivalScope;
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder:
            (_) => HistoryWrapper(
              festivalScope: festivalScope,
              child: BandDetailView(bandName),
            ),
        fullscreenDialog: true,
      ),
    );
  }

  static FestivalConfig get _config => dimeGet<FestivalConfig>();
  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  Logger get _log => const Logger(module: 'BandDetailView');

  String _buildFlag(String country) =>
      String.fromCharCodes(country.runes.map((code) => code + 127397));

  String get _fallbackText => 'Sorry, no info'.i18n;

  String _getDescription(Locale locale, Band band) =>
      band.descriptionForLocale(locale) ?? _fallbackText;

  Widget _buildDetailRow(ThemeData theme, String title, String value) =>
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Text('${title.i18n}:', style: theme.textTheme.titleSmall),
            ),
            Flexible(flex: 7, fit: FlexFit.tight, child: Text(value)),
          ],
        ),
      );

  Widget _buildDetails(ThemeData theme, Locale locale, Band band) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(_getDescription(locale, band)),
      ),
      _buildDetailRow(
        theme,
        'Origin',
        band.optionalOrigin.map(_buildFlag).orElse(_fallbackText),
      ),
      OptionalBuilder(
        optional: band.optionalStyle,
        builder: (_, styleValue) => _buildDetailRow(theme, 'Style', styleValue),
      ),
      OptionalBuilder(
        optional: band.optionalRoots,
        builder: (_, rootsValue) => _buildDetailRow(theme, 'Roots', rootsValue),
      ),
      const SizedBox(height: 10),
      OptionalBuilder(
        optional: band.spotifyUrl,
        builder:
            (_, url) => Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _theme.primaryButton(
                label: 'Play on Spotify'.i18n,
                onPressed: () {
                  launchUrl(url, mode: LaunchMode.externalApplication);
                },
              ),
            ),
      ),
    ],
  );

  Widget _buildImage(ThemeData theme, String imgUrl, [ImageData? imgData]) =>
      Stack(
        children: [
          if (imgData?.hasHash ?? false) BlurHash(hash: imgData!.hash!),
          CachedNetworkImage(
            imageUrl: imgUrl,
            errorWidget: (_, _, _) => Container(),
            placeholder:
                (_, _) => Shimmer.fromColors(
                  baseColor: Colors.transparent,
                  highlightColor: _theme.shimmerColor,
                  loop: 1,
                  child: Container(color: theme.scaffoldBackgroundColor),
                ),
            placeholderFadeInDuration: const Duration(milliseconds: 1500),
            imageBuilder:
                (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: imageProvider),
                  ),
                ),
          ),
        ],
      );

  Widget _buildBandLogo(ThemeData theme, String imgUrl, ImageData? imgData) =>
      Container(
        color: Colors.black,
        height: 100,
        alignment: Alignment.center,
        child: _buildImage(theme, imgUrl, imgData),
      );

  Widget _buildBandImage(ThemeData theme, String imgUrl, ImageData? imgData) =>
      (imgData?.hasRatio ?? false)
          ? AspectRatio(
            aspectRatio: imgData!.ratio,
            child: _buildImage(theme, imgUrl, imgData),
          )
          : _buildImage(theme, imgUrl);

  Widget get _fallbackInfo => Container(
    padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
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
        EventDate(start: event.start, end: event.end, showWeekDay: true),
        EventPlayingIndicator(isPlaying: event.isPlaying(currentDate())),
        EventStage(event.stage),
      ],
    ),
  );

  Widget _buildMultiEventEntry(ImmortalList<Event> events) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 7),
    child: DenseEventList(events: events, currentTime: currentDate()),
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
            child:
                bandWithEvents.events.length == 1
                    ? _buildSingleEventEntry(bandWithEvents.events.first)
                    : _buildMultiEventEntry(bandWithEvents.events),
          );

  Widget _buildBandView(BuildContext context, BandWithEvents bandWithEvents) {
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final band = bandWithEvents.band;
    return Container(
      alignment: Alignment.topCenter,
      child: Scrollbar(
        child: ListView(
          children: <Widget>[
            OptionalBuilder(
              optional: Optional.ofNullable(
                band.map((bandValue) => bandValue.nonEmptyLogo).orElseNull,
              ),
              builder:
                  (_, logoValue) =>
                      _buildBandLogo(theme, logoValue, band.value.logoData),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Text(
                bandName.toUpperCase(),
                style: theme.textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
            ),
            _buildEvents(bandWithEvents),
            band
                .map<Widget>(
                  (b) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: _buildDetails(theme, locale, b),
                  ),
                )
                .orElse(_fallbackInfo),
            OptionalBuilder(
              optional: Optional.ofNullable(
                band.map((bandValue) => bandValue.nonEmptyImage).orElseNull,
              ),
              builder:
                  (_, imageValue) => Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: _buildBandImage(
                      theme,
                      imageValue,
                      band.value.imageData,
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final festivalScope = DimeFlutter.get<FestivalScope>(context);
    final bandProvider = ref.watch(
      dimeGet<BandWithEventsProvider>()(
        BandKey(festivalId: festivalScope.festivalId, bandName: bandName),
      ),
    );
    return AppScaffold.forDialog(
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
