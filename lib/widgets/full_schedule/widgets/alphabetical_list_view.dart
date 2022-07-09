import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../../../models/theme.dart';
import 'animated_list_view.dart';
import 'divided_list_tile.dart';

typedef AlphabeticalIndexGetter = String Function(int);
typedef ListItemBuilder = Widget Function(BuildContext, int);

class AlphabeticalListView extends StatefulWidget {
  const AlphabeticalListView({
    required this.itemCount,
    required this.listItemHeights,
    required this.getAlphabeticalIndex,
    required this.buildListItem,
    required this.itemIds,
  });

  final ImmortalList<double> listItemHeights;
  final AlphabeticalIndexGetter getAlphabeticalIndex;
  final AnimatedListViewBuilder buildListItem;
  final int itemCount;
  final ImmortalList<String> itemIds;

  @override
  State<StatefulWidget> createState() => _AlphabeticalListViewState();
}

class _AlphabeticalListViewState extends State<AlphabeticalListView> {
  int _currentPosition = 0;
  late ScrollController _scrollController;
  late ImmortalList<double> _listItemOffsets;

  FestivalTheme get _theme => dimeGet<FestivalTheme>();

  bool get _displayIndices =>
      widget.itemCount >= _theme.minItemCountForAlphabeticalIndex;

  void _calculateOffsets() {
    var currentOffset = 0.0;
    _listItemOffsets = widget.listItemHeights.map((height) {
      final offset = currentOffset;
      currentOffset += height;
      return offset;
    });
  }

  @override
  void initState() {
    _calculateOffsets();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      final newPosition =
          _listItemOffsets.lastIndexWhere((itemOffset) => itemOffset <= offset);
      if (newPosition != _currentPosition) {
        setState(() {
          _currentPosition = newPosition;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AlphabeticalListView oldWidget) {
    _calculateOffsets();
    super.didUpdateWidget(oldWidget);
  }

  bool _showLetterAtListItem(int index) {
    final alphabeticalIndex = widget.getAlphabeticalIndex(index);
    if (index != _currentPosition &&
        (index == 0 ||
            alphabeticalIndex != widget.getAlphabeticalIndex(index - 1))) {
      return true;
    }
    return index == _currentPosition &&
        index < widget.itemCount - 1 &&
        alphabeticalIndex != widget.getAlphabeticalIndex(index + 1);
  }

  Widget _buildAlphabeticalIndex({
    required BuildContext context,
    required int index,
    bool isVisible = false,
  }) =>
      Opacity(
        opacity: isVisible ? 1 : 0,
        child: Container(
          width: _theme.alphabeticalIndexWidth,
          alignment: Alignment.topCenter,
          child: Text(
            widget.getAlphabeticalIndex(index),
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      );

  Widget _buildListItemWithAlphabeticalIndex({
    required BuildContext context,
    required Animation<double> animation,
    required int index,
    required String itemId,
  }) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(child: _buildListItem(context, animation, index, itemId)),
          FadeTransition(
            opacity: animation,
            child: _buildAlphabeticalIndex(
              context: context,
              index: index,
              isVisible: _displayIndices && _showLetterAtListItem(index),
            ),
          ),
        ],
      );

  Widget _buildListItem(
    BuildContext context,
    Animation<double> animation,
    int index,
    String itemId,
  ) =>
      DividedListTile(
        isLast: index == widget.itemCount - 1,
        child: widget.buildListItem(
          context: context,
          animation: animation,
          index: index,
          itemId: itemId,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final listView = AnimatedListView(
      scrollController: _scrollController,
      initialItemCount: widget.itemCount,
      itemBuilder: _buildListItemWithAlphabeticalIndex,
      itemIds: widget.itemIds,
    );
    return Stack(
      children: <Widget>[
        listView,
        Positioned(
          top: 0,
          right: 0,
          child: AnimatedOpacity(
            opacity: _displayIndices ? 1.0 : 0.0,
            child: _buildAlphabeticalIndex(
              context: context,
              index: _currentPosition,
              isVisible: !_showLetterAtListItem(_currentPosition),
            ),
            duration: const Duration(milliseconds: 250),
          ),
        ),
      ],
    );
  }
}
