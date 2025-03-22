import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'loadingIndicator.dart';

part 'loadableErrorPage.dart';

class LoadablePageBuilder<T> extends StatefulWidget {
  final Future<T> Function() future;
  final LoadableController? controller;
  final Widget Function(BuildContext, T?) builder;
  final LoadingIndicatorOptions loadingIndicatorOptions;
  final LoadableErrorController? errorHandler;
  final bool skipLoading;
  const LoadablePageBuilder({super.key, required this.loadingIndicatorOptions, required this.future, required this.builder, this.errorHandler, this.controller, this.skipLoading = false});

  @override
  State<LoadablePageBuilder<T>> createState() => _LoadablePageBuilderState<T>();
}

class _LoadablePageBuilderState<T> extends State<LoadablePageBuilder<T>> {

  Future<T?> _future() async {
    if (widget.skipLoading) {
      return null;
    }

    T? cached = widget.controller?._checkForCached();
    if (cached != null) {
      return cached;
    }

    T res = await widget.future();

    widget.controller?._callOnLoadFinished(res);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T?>(
      future: _future(),
      builder: (context, snapshot) {
        if (widget.skipLoading) {
          return widget.builder(context, null);
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingIndicator(options: widget.loadingIndicatorOptions);
        } else if (snapshot.hasError) {
          if(kDebugMode) {
            print(snapshot.error);
          }

          if (widget.errorHandler != null) {
            // If error handler is provided, use it to handle the error
            widget.errorHandler!.throwError(snapshot.error as Exception);
            return LoadingIndicator(options: widget.loadingIndicatorOptions);
          } else {
            // If error handler is not provided, show the error indicator
            return _ErrorIndicatorWidget(onReloadTry: () {
              setState(() {});
            });
          }
        }
        return widget.builder(context, snapshot.data);
      },
    );
  }
}

class LoadableController<T> {
  bool cacheResponse;

  Function(T snapShot)? _onFirstLoad;
  Function(T snapShot)? _onLoad;
  int _numberOfLoading = 0;
  T? cached;

  LoadableController({this.cacheResponse = false, Function(T snapShot)? onFirstLoad, Function(T snapShot)? onLoad}) {
    _onFirstLoad = onFirstLoad;
    _onLoad = onLoad;
  }

  void enableCaching(bool val) {
    cacheResponse = val;
  }

  void _callOnLoadFinished(T data) {
    if (_onFirstLoad != null && _numberOfLoading == 0) {
      _onFirstLoad!(data);
    }
    if (_onLoad != null) {
      _onLoad!(data);
    }
    cached = data;
    _numberOfLoading++;
  }

  T? _checkForCached () {
    if (cacheResponse && cached != null) {
      return cached;
    }
    return null;
  }
}