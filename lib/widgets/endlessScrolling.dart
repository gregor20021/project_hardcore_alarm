import 'package:flutter/cupertino.dart';

class EndlessScrolling<T> extends StatefulWidget {
  final int loadPerTime;
  final List<T> entities;
  final Widget Function(T entity) itemBuilder;
  final bool includeBottomPadding;
  const EndlessScrolling({super.key, required this.entities, required this.itemBuilder, required this.loadPerTime, this.includeBottomPadding = true});

  @override
  State<EndlessScrolling<T>> createState() => _EndlessScrollingState<T>();
}

class _EndlessScrollingState<T> extends State<EndlessScrolling<T>> {
  bool loadingData = false;
  int _pageIndex = 1;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      updateList(wait: true);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => updateList());
  }

  updateList({bool wait = false}) async {
    if (_scrollController.position.pixels > _scrollController.position.maxScrollExtent + 60 && !loadingData) {
      if (widget.entities.length < _pageIndex * widget.loadPerTime) return;
      if (wait) {
        setState(() {
          loadingData = true;
        });
        await Future.delayed(Duration(milliseconds: 300));
      }
      setState(() {
        loadingData = false;
        _pageIndex++;
      });
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    updateList();
  }

  @override
  Widget build(BuildContext context) {
    int endIndex = _pageIndex * widget.loadPerTime;
    if (endIndex > widget.entities.length) {
      endIndex = widget.entities.length;
    }
    return Stack(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          controller: _scrollController,
          child: Column(
            children: [
              ...widget.entities.sublist(0, endIndex).map((e) => widget.itemBuilder(e as T)).toList(),
              if(widget.includeBottomPadding) SizedBox(height: 60),
            ],
          ),
        ),
        if (loadingData) const Positioned(
          bottom: 5,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CupertinoActivityIndicator(radius: 12,),
          ),
        ),
      ],
    );
  }
}
