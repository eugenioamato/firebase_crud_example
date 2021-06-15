import 'dart:async';

class DatabaseInterface {
  void init(String s, Future<void> Function() startListening) {}

  exists(String s, String t) {}

  set(String s, String t, Map<String, String> map) {}

  read(String s, String t) {}

  update(String s, String t, Map<String, String> map) {}

  listen(String s, void Function(dynamic events) manageEvent) {}

  delete(String s, String t) {}
}
