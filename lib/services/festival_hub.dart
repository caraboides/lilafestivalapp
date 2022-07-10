import 'dart:convert';

import 'package:dime/dime.dart';
import 'package:http/http.dart' as http;
import 'package:optional/optional.dart';

import '../models/global_config.dart';
import '../utils/logging.dart';

class FestivalHub {
  const FestivalHub();

  GlobalConfig get _config => dimeGet<GlobalConfig>();
  Logger get _log => const Logger(module: 'FESTIVAL_HUB');

  Future<Optional<J>> loadJsonData<J>(String url) async {
    _log.debug('Loading data from $url');
    try {
      final response =
          await http.get(Uri.parse('${_config.festivalHubBaseUrl}$url'));
      if (response.statusCode == 200) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        _log.debug('Loading data from $url was successful');
        return Optional<J>.of(json);
      } else {
        _log.error('Loading data from $url failed', response.body);
      }
    } catch (error) {
      _log.error('Error loading data from $url', error);
    }
    return Optional<J>.empty();
  }
}
