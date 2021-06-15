class LoadingStateHelper {
  LoadingStateHelper();
  bool _loading = false;

  void startLoading(callback) {
    _loading = true;
    callback();
  }

  void stopLoading(callback) {
    _loading = false;
    callback();
  }

  bool isLoading() => _loading;
}
