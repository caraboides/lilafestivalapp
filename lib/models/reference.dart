import 'package:immortal/immortal.dart';

class Link {
  const Link({
    this.url,
    this.label,
    this.imageAssetPath,
  });

  final String url;
  final String label;
  final String imageAssetPath;
}

class Reference {
  const Reference({
    this.label,
    this.links,
  });

  final String label;
  final ImmortalList<Link> links;
}
