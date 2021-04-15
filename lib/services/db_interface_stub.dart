import 'dart:async';

class DatabaseInterface
{
  void init(String s, Future<void> Function() startListening) {}

  exists(String s, String t) {}

  set(String s, String t, Map<String, String> map) {}

  read(String s, String t) {}

  update(String s, String t, Map<String, String> map) {}

  StreamSubscription listen(String s, void Function(dynamic events) manageEvent) {
    return Stream.periodic(Duration(seconds: 10)).listen((event) { });
  }

  delete(String s, String t) {}
  
}