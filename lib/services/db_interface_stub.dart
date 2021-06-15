import 'dart:async';

class DatabaseInterface {
  Future<void> init() async {}

  exists(String s, String t) {}

  set(String s, String t, Map<String, dynamic> map) {}

  read(String s, String t) {}

  update(String s, String t, Map<String, dynamic> map) {}

  listen(String s, void Function(dynamic events) manageEvent) {}

  delete(String s, String t) {}
}
