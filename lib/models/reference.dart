import 'package:immortal/immortal.dart';

class Link {
  const Link({
    required this.url,
    this.label,
    this.imageAssetPath,
  });

  final Uri url;
  final String? label;
  final String? imageAssetPath;
}

class Reference {
  const Reference({
    required this.links,
    this.label,
  });

  final String? label;
  final ImmortalList<Link> links;
}
