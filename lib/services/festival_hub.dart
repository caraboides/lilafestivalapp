import 'dart:convert';

import 'package:dime/dime.dart';
import 'package:http/http.dart' as http;
import 'package:optional/optional.dart';

import '../models/global_config.dart';

class FestivalHub {
  const FestivalHub();

  GlobalConfig get _config => dimeGet<GlobalConfig>();

  Future<Optional<J>> loadJsonData<J>(String url) async {
    final response = await http.get('${_config.festivalHubBaseUrl}$url');
    if (response.statusCode == 200) {
      return Optional<J>.of(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    return Optional<J>.empty();
  }
}
