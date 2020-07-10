import 'dart:convert';

import 'package:dime/dime.dart';
import 'package:http/http.dart' as http;
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

import '../models/event.dart';
import '../models/global_config.dart';

class FestivalHub {
  const FestivalHub();

  GlobalConfig get _config => dimeGet<GlobalConfig>();

  Future<Optional<ImmortalList<Event>>> loadSchedule(String festivalId) async {
    final response = await http
        .get('${_config.festivalHubBaseUrl}/schedule?festival=$festivalId');
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap =
          jsonDecode(utf8.decode(response.bodyBytes));
      // TODO(SF) STATE error handling
      final events = ImmortalMap<String, dynamic>(jsonMap)
          .mapEntries<Event>((id, json) => Event.fromJson(id, json));
      return Optional.of(events);
    }
    return const Optional.empty();
  }

  Future<Optional<J>> loadJsonData<J>(String url) async {
    final response = await http.get('${_config.festivalHubBaseUrl}$url');
    if (response.statusCode == 200) {
      return Optional<J>.of(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    return Optional<J>.empty();
  }
}
