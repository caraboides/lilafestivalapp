import 'package:flutter/foundation.dart';
import 'package:immortal/immortal.dart';

class Link {
  const Link({
    @required this.url,
    this.label,
    this.imageAssetPath,
  });

  final String url;
  final String label;
  final String imageAssetPath;
}

class Reference {
  const Reference({
    @required this.links,
    this.label,
  });

  final String label;
  final ImmortalList<Link> links;
}
