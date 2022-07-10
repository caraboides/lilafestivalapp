import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import 'ids.dart';

class ImageData {
  const ImageData({
    this.width,
    this.height,
    this.hash,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
        width: json['width'],
        height: json['height'],
        hash: json['hash'],
      );

  final int? width;
  final int? height;
  final String? hash;

  bool get hasRatio => width != null && height != null && height! > 0;

  double get ratio => hasRatio ? width! / height! : 1;

  bool get hasHash => hash != null && hash != '';
}

bool _isValueSet(String? value) => value?.isNotEmpty ?? false;

String? _nonEmptyValue(String? value) => _isValueSet(value) ? value : null;

Optional<String> _valueAsOptional(String? value) =>
    Optional.ofNullable(_nonEmptyValue(value));

class Band {
  Band({
    required this.name,
    this.spotify,
    this.image,
    this.imageData,
    this.logo,
    this.logoData,
    this.origin,
    this.style,
    this.roots,
    this.textDe,
    this.textEn,
    this.cancelled = false,
  });

  factory Band.fromJson(String bandName, Map<String, dynamic> json) => Band(
        name: bandName,
        image: json['img'],
        imageData: ImageData.fromJson(json['imgData'] ?? {}),
        logo: json['logo'],
        logoData: ImageData.fromJson(json['logoData'] ?? {}),
        spotify: json['spotify'],
        origin: json['origin'],
        style: json['style'],
        roots: json['roots'],
        textDe: json['description'],
        textEn: json['description_en'],
        cancelled: json['cancelled'] ?? false,
      );

  final BandName name;
  final String? image;
  final ImageData? imageData;
  final String? logo;
  final ImageData? logoData;
  final String? spotify;
  final String? origin;
  final String? style;
  final String? roots;
  final String? textDe;
  final String? textEn;
  final bool cancelled;

  Optional<Uri> get spotifyUrl => _valueAsOptional(spotify).map(Uri.parse);

  Optional<String> get optionalOrigin => _valueAsOptional(origin);

  Optional<String> get optionalStyle => _valueAsOptional(style);

  Optional<String> get optionalRoots => _valueAsOptional(roots);

  String? get nonEmptyImage => _nonEmptyValue(image);

  String? get nonEmptyLogo => _nonEmptyValue(logo);

  String? descriptionForLocale(Locale locale) {
    if (locale.languageCode == 'de' && _isValueSet(textDe)) {
      return textDe!;
    }
    return _nonEmptyValue(textEn);
  }
}
