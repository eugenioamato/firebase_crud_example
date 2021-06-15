class Helper {
  static bool _loading = false;

  static void startLoading(callback) {
    _loading = true;
    callback();
  }

  static void stopLoading(callback) {
    _loading = false;
    callback();
  }

  static bool isLoading() => _loading;
}
