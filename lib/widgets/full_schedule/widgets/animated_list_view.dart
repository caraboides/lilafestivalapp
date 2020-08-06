import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

typedef AnimatedListViewBuilder = Widget Function({
  @required BuildContext context,
  @required Animation<double> animation,
  @required int index,
  @required String itemId,
});

class AnimatedListView extends StatefulWidget {
  const AnimatedListView({
    @required this.initialItemCount,
    @required this.itemBuilder,
    @required this.itemIds,
    this.scrollController,
  });

  final ScrollController scrollController;
  final int initialItemCount;
  final AnimatedListViewBuilder itemBuilder;
  final ImmortalList<String> itemIds;

  @override
  State<StatefulWidget> createState() => _AnimatedListViewState();
}

class _AnimatedListViewState extends State<AnimatedListView> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  static final _fadeTween =
      Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOut));

  Widget _animated(
          {@required Animation<double> animation, @required Widget child}) =>
      SizeTransition(
        sizeFactor: animation,
        child: FadeTransition(
          opacity: animation.drive(_fadeTween),
          child: child,
        ),
      );

  @override
  void didUpdateWidget(AnimatedListView oldWidget) {
    if (mounted && widget.itemIds != oldWidget.itemIds) {
      final newItemIndices =
          widget.itemIds.asMap().map((index, id) => MapEntry(id, index));
      final oldItemIndices =
          oldWidget.itemIds.asMap().map((index, id) => MapEntry(id, index));
      // Remove old events, starting at the end
      oldWidget.itemIds.removeAll(widget.itemIds).reversed.forEach((itemId) =>
          oldItemIndices[itemId]
              .map((index) => _listKey.currentState.removeItem(
                    index,
                    (context, animation) => _animated(
                      animation: animation,
                      child: widget.itemBuilder(
                        context: context,
                        animation: animation,
                        index: index,
                        itemId: itemId,
                      ),
                    ),
                  )));
      // Insert new events, starting at the beginning
      widget.itemIds.removeAll(oldWidget.itemIds).forEach((itemId) {
        newItemIndices[itemId]
            .map((index) => _listKey.currentState.insertItem(index));
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => AnimatedList(
        key: _listKey,
        controller: widget.scrollController,
        initialItemCount: widget.initialItemCount,
        itemBuilder: (context, index, animation) => widget.itemIds[index]
            .map<Widget>(
              (itemId) => _animated(
                animation: animation,
                child: widget.itemBuilder(
                    context: context,
                    animation: animation,
                    index: index,
                    itemId: itemId),
              ),
            )
            .orElse(Container()),
      );
}
