import 'package:flutter/material.dart';
import 'views/homepage.dart';

class FirebaseCrudExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
