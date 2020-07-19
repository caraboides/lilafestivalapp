import 'package:flutter/foundation.dart';

class Band {
  Band({
    @required this.name,
    this.spotify,
    this.image,
    this.logo,
    this.origin,
    this.style,
    this.roots,
    this.textDe,
    this.textEn,
  });

  factory Band.fromJson(String bandName, Map<String, dynamic> json) => Band(
        name: bandName,
        image: json['img'],
        logo: json['logo'],
        spotify: json['spotify'],
        origin: json['origin'],
        style: json['style'],
        roots: json['roots'],
        textDe: json['description'],
        textEn: json['description_en'],
      );

  final String name;
  final String image;
  final String logo;
  final String spotify;
  final String origin;
  final String style;
  final String roots;
  final String textDe;
  final String textEn;
}
