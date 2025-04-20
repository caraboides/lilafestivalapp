import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/reference.dart';

class LinkButton extends StatelessWidget {
  const LinkButton({
    required this.link,
    this.shrink = false,
    this.dense = false,
    this.textEllipsis = false,
  });

  final Link link;
  final bool shrink;
  final bool dense;
  final bool textEllipsis;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: link.url.toString(),
    child: TextButton(
      onPressed:
          () => launchUrl(link.url, mode: LaunchMode.externalApplication),
      style: ButtonStyle(
        tapTargetSize:
            shrink
                ? MaterialTapTargetSize.shrinkWrap
                : MaterialTapTargetSize.padded,
        visualDensity: dense ? VisualDensity.compact : VisualDensity.standard,
      ),
      child: Text(
        link.label ?? link.url.toString(),
        overflow: textEllipsis ? TextOverflow.ellipsis : null,
      ),
    ),
  );
}
