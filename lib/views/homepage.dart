import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_crud_example/services/data_repository.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import '../loading_state_helper.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'custom_action_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();
  late StreamSubscription listener;

  Key formKey = Key('form');
  double step = 0.0;
  double vstep = 0.0;
  String formCaption = 'Ready!';
  Color formColor = Colors.black;
  bool formVisible = true;
  bool waitingForFirstConnection = true;
  List _dbMessages = [];
  late LoadingStateHelper _helper;
  late DataRepository _dataRepository;

  String get dbMessages => _dbMessages.toString();

  Future<void> startListening() async {
    listener = _dataRepository.listen('users', manageEvent);
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  initState() {
    _helper = LoadingStateHelper();
    _helper.startLoading(refresh);
    _dataRepository = DataRepository(startListening);
    super.initState();
  }

  dispose() {
    listener.cancel();
    scrollController.dispose();
    super.dispose();
  }

  void showErrorSnackbar(String text, bool short) {
    SnackBar errorSnackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
      duration: Duration(seconds: short ? 5 : 5000),
    );
    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }

  bool errorInConnectivity = false;

  void manageEvent(events) {
    if (waitingForFirstConnection) {
      if (events.toString() == '()') {
        showErrorSnackbar('No Internet connection!', false);
        errorInConnectivity = true;
      } else {
        if (errorInConnectivity) {
          errorInConnectivity = false;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
        waitingForFirstConnection = false;
        _helper.stopLoading(refresh);
      }
    }
    _dbMessages.clear();
    _dbMessages.addAll(events);
    refresh();
  }

  Future<void> _showMessage(String messageTitle, String message, String okCaption, Color textColor) async {
    setState(() {
      formCaption = message;
      formColor = textColor;
    });
    if (!formVisible) scrollController.animateTo(0, duration: Duration(seconds: 1), curve: Curves.linear);
  }

  void _noConnectivity() {
    errorInConnectivity = true;
    waitingForFirstConnection = true;
    showErrorSnackbar('No Internet connection!', true);
  }

  void _create() {
    _dataRepository.createData(
      'users',
      'testUser',
      <String, dynamic>{
        'firstName': 'Sandro',
        'lastName': 'Manzoni',
      },
      'Record written Successfully',
      'ERROR ON CREATE: THE RECORD ALREADY EXISTS',
      _helper,
      refresh,
      _showMessage,
      _noConnectivity,
    );
  }

  void _read() async {
    _dataRepository.readData(
      'users',
      'testUser',
      'Data found',
      'ERROR ON READ, THE RECORD WAS NOT FOUND',
      _helper,
      refresh,
      _showMessage,
      _noConnectivity,
    );
  }

  void _update() async {
    _dataRepository.updateData(
      'users',
      'testUser',
      {
        'firstName': 'Alessandro',
      },
      'Record updated Successfully! The name is changed to Alessandro',
      'ERROR ON UPDATE, THE RECORD WAS NOT FOUND',
      _helper,
      refresh,
      _showMessage,
      _noConnectivity,
    );
  }

  void _delete() async {
    _dataRepository.deleteData(
      'users',
      'testUser',
      'Record deleted Successfully!',
      'ERROR ON DELETE: THE RECORD DOESN`T EXIST',
      _helper,
      refresh,
      _showMessage,
      _noConnectivity,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (step == 0.0) {
      Size size = MediaQuery.of(context).size;
      step = size.width / 20.0;
      vstep = size.height / 30.0;
    }

    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, Colors.white, Colors.white, Colors.cyanAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              toolbarHeight: vstep,
              title: _helper.isLoading()
                  ? LinearProgressIndicator(minHeight: vstep)
                  : Container(
                      color: Colors.transparent,
                    ),
            ),
            body: Padding(
              padding: EdgeInsets.only(left: step, right: step),
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: pageItems.length,
                  itemBuilder: (context, index) => pageItems[index]),
            ),
          ),
        ));
  }

  List<Widget> get pageItems => [
        Image.asset(
          'assets/images/flutter_logo.png',
          height: vstep * 8.0,
        ),
        Image.asset(
          'assets/images/firebase_logo.png',
          height: vstep * 7.0,
        ),
        SizedBox(
          height: vstep * 2.0,
        ),
        Center(
            child: VisibilityDetector(
          key: formKey,
          onVisibilityChanged: (VisibilityInfo info) {
            formVisible = info.visibleFraction == 1.0;
          },
          child: AutoSizeText(
            formCaption,
            maxLines: 2,
            style: TextStyle(color: formColor),
            semanticsLabel: 'formCaption',
          ),
        )),
        SizedBox(
          height: vstep,
        ),
        CustomActionButton('Create', Icons.create, _create, _helper.isLoading()),
        SizedBox(
          height: vstep,
        ),
        CustomActionButton('Read', Icons.read_more, _read, _helper.isLoading()),
        SizedBox(
          height: vstep,
        ),
        CustomActionButton('Update', Icons.update, _update, _helper.isLoading()),
        SizedBox(
          height: vstep,
        ),
        CustomActionButton('Delete', Icons.delete, _delete, _helper.isLoading()),
        SizedBox(
          height: vstep,
        ),
        AutoSizeText(dbMessages),
        SizedBox(
          height: vstep,
        ),
      ];
}
