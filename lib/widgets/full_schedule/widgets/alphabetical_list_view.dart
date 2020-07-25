import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../../../models/theme.dart';
import 'divided_list_tile.dart';

typedef AlphabeticalIndexGetter = String Function(int);
typedef ListItemBuilder = Widget Function(BuildContext, int);

class AlphabeticalListView extends StatefulWidget {
  const AlphabeticalListView({
    @required this.itemCount,
    @required this.listItemHeights,
    @required this.getAlphabeticalIndex,
    @required this.buildListItem,
  });

  final ImmortalList<double> listItemHeights;
  final AlphabeticalIndexGetter getAlphabeticalIndex;
  final ListItemBuilder buildListItem;
  final int itemCount;

  @override
  State<StatefulWidget> createState() => _AlphabeticalListViewState();
}

class _AlphabeticalListViewState extends State<AlphabeticalListView> {
  int _currentPosition = 0;
  ScrollController _scrollController;
  ImmortalList<double> _listItemOffsets;

  FestivalTheme get _theme => dimeGet<FestivalTheme>();

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
    @required BuildContext context,
    @required int index,
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

  Widget _buildListItem(BuildContext context, int index) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: _buildListItemWithoutAlphabeticalIndex(context, index),
          ),
          _buildAlphabeticalIndex(
            context: context,
            index: index,
            isVisible: _showLetterAtListItem(index),
          ),
        ],
      );

  Widget _buildListItemWithoutAlphabeticalIndex(
    BuildContext context,
    int index,
  ) =>
      DividedListTile(
        isLast: index == widget.itemCount - 1,
        child: widget.buildListItem(context, index),
      );

  @override
  Widget build(BuildContext context) =>
      widget.itemCount < _theme.minItemCountForAlphabeticalIndex
          ? ListView.builder(
              itemCount: widget.itemCount,
              itemBuilder: _buildListItemWithoutAlphabeticalIndex,
            )
          : Stack(
              children: <Widget>[
                ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.itemCount,
                  itemBuilder: _buildListItem,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: _buildAlphabeticalIndex(
                    context: context,
                    index: _currentPosition,
                    isVisible: !_showLetterAtListItem(_currentPosition),
                  ),
                ),
              ],
            );
}
