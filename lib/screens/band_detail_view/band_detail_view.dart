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

class BandDetailView extends StatelessWidget {
  const BandDetailView(this.enhancedEvent);

  final EnhancedEvent enhancedEvent;

  Event get event => enhancedEvent.event;

  String _buildFlag(String country) =>
      String.fromCharCodes(country.runes.map((code) => code + 127397));

  String _getDescription(Locale locale, Band band) {
    if (locale.languageCode == 'de' && (band.textDe ?? '') != '') {
      return band.textDe;
    }
    return band.textEn ?? 'Sorry, no info'.i18n;
  }

  List<Widget> _buildDetails(
    FestivalTheme theme,
    Locale locale,
    Band band,
  ) =>
      <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 15),
          child: Text(_getDescription(locale, band)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 75,
                child: Text(
                  '${'Origin'.i18n}:',
                  style: theme.bandDetailTextStyle,
                ),
              ),
              Text(band.origin != null
                  ? _buildFlag(band.origin)
                  : 'Sorry, no info'.i18n),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: band.style == null || band.style.trim() == ''
              ? Container()
              : Row(
                  children: <Widget>[
                    SizedBox(
                      width: 75,
                      child: Text(
                        '${'Style'.i18n}:',
                        style: theme.bandDetailTextStyle,
                      ),
                    ),
                    Text(band.style ?? 'Sorry, no info'.i18n),
                  ],
                ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: band.roots == null || band.roots.trim() == ''
              ? Container()
              : Row(
                  children: <Widget>[
                    SizedBox(
                      width: 75,
                      child: Text(
                        '${'Roots'.i18n}:',
                        style: theme.bandDetailTextStyle,
                      ),
                    ),
                    Text(band.roots ?? 'Sorry, no info'.i18n),
                  ],
                ),
        ),
        if ((band.spotify ?? '') != '')
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 15),
            child: theme.primaryButton(
              label: 'Play on Spotify'.i18n,
              onPressed: () {
                launch(band.spotify);
              },
            ),
          ),
        if ((band.image ?? '') != '')
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: CachedNetworkImage(
              imageUrl: band.image,
            ),
          ),
      ];

  Widget _buildBandView(BuildContext context, Optional<Band> band) {
    final locale = Localizations.localeOf(context);
    final theme = dimeGet<FestivalTheme>();
    return Scaffold(
      appBar: theme.appBar('Band Details'.i18n),
      body: Container(
        alignment: Alignment.topCenter,
        child: ListView(
          children: <Widget>[
            band
                .map<Widget>((d) => (d.logo ?? '') != ''
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
                event.bandName.toUpperCase(),
                style: theme.bandNameTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5, right: 20, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  EventToggle(
                    isActive: enhancedEvent.isScheduled,
                    onToggle: enhancedEvent.toggleEvent,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: EventDate(
                      start: event.start,
                      end: event.end,
                      showWeekDay: true,
                    ),
                  ),
                  EventStage(event.stage),
                ],
              ),
            ),
            ...band
                .map<List<Widget>>((d) => _buildDetails(theme, locale, d))
                .orElse(<Widget>[
              Container(
                padding: const EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 20),
                alignment: Alignment.center,
                child: Text('Sorry, no info'.i18n),
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
        final bandsProvider = read(dimeGet<BandsProvider>());
        return bandsProvider.when(
          data: (bands) => _buildBandView(context, bands.get(event.bandName)),
          // TODO(SF)
          loading: () => Center(child: Text('Loading!')),
          error: (e, trace) => Center(
            child: Text('Error! $e ${trace.toString()}'),
          ),
        );
      });
}
