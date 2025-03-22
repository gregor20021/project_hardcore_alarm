part of 'loadablePageBuilder.dart';

class LoadableErrorPageBuilder extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  final LoadableErrorController errorController;
  const LoadableErrorPageBuilder({super.key, required this.builder, required this.errorController});

  @override
  State<LoadableErrorPageBuilder> createState() => _LoadableErrorPageBuilderState();
}

class _LoadableErrorPageBuilderState extends State<LoadableErrorPageBuilder> {
  Function? errorListener;

  @override
  void initState() {
    super.initState();
    widget.errorController.addListener(() {
      if (mounted) {
        Future.delayed(Duration.zero,() {
          setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.errorController.hasError) {
      return _ErrorIndicatorWidget(onReloadTry: () {
        widget.errorController.resetError();
      });
    } else {
      return widget.builder(context);
    }
  }
}

class _ErrorIndicatorWidget extends StatelessWidget {
  const _ErrorIndicatorWidget({
    super.key,
    required this.onReloadTry,
  });

  final Function() onReloadTry;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    width: 250,
                    "assets/images/no_internet.png",
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Text(
                    "Prišlo je do napake pri nalaganju podatkov, poskusite ponovno.",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(onPressed: () {
                  onReloadTry();
                }, icon: Icon(Icons.refresh, color: Theme.of(context).primaryColor, size: 35,))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoadableErrorController extends ChangeNotifier {
  bool _hasError = false;
  bool get hasError => _hasError;

  void throwError(Exception e) {
    _hasError = true;
    notifyListeners();
  }

  void resetError() {
    _hasError = false;
    notifyListeners();
  }
}
