import 'package:flutter/material.dart';
import 'package:pokedex/widgets/empty_footer.dart';
import 'package:pokedex/widgets/progress_indicator_footer.dart';

class InfiniteScrollGrid extends StatelessWidget {
  final ScrollController scrollController;
  final SliverGridDelegate gridDelegate;
  final SliverChildDelegate delegate;
  final bool isLoadingMoreData;

  const InfiniteScrollGrid({
    this.scrollController,
    this.gridDelegate,
    this.delegate,
    this.isLoadingMoreData,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverGrid(
          gridDelegate: gridDelegate,
          delegate: delegate,
        ),
        !isLoadingMoreData
            ? SliverToBoxAdapter(child: EmptyFooter())
            : SliverToBoxAdapter(child: ProgressIndicatorFooter())
      ],
    );
  }
}
