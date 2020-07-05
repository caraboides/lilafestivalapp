import 'package:immortal/immortal.dart';

class Link {
  const Link({this.url, this.label});

  final String url;
  final String label;
}

class Reference {
  const Reference({
    this.label,
    this.links,
  });

  final String label;
  final ImmortalList<Link> links;
}
