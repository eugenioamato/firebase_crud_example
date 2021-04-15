import 'dart:async';
import 'dart:collection';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:roomsgame/models/room.dart';
import 'package:roomsgame/views/roompage.dart';
import '../helper.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../services/db_interface_stub.dart'
    if (dart.library.io) '../services/database_interface.dart'
    if (dart.library.html) '../services/web_database_interface.dart';

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

  var nameController=TextEditingController();

  List<Widget> get pageItems => [
        Image.asset(
          'assets/images/flutter_logo.png',
          height: vstep * 8.0,
        ),
        SizedBox(
          height: vstep * 2.0,
        ),

        Container(
          height: 200,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: step*6),
            children: [
          Text('Please insert your name',textAlign: TextAlign.center,style: h2Style,),
          TextField(controller: nameController,),
          ],),
        ),
        SizedBox(height: 40,),
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
        buildRoomList(dbMessages),
        SizedBox(
          height: vstep,
        ),
    Center(
      child: Container(
        padding: EdgeInsets.all(20),
        color: Colors.green,
        child: TextButton(onPressed: createNewRoom,
            child:Text('Create new Room',
            style: h2Style,
            )),
      ),
    ),
    SizedBox(height: 40,)
      ];

  List<dynamic> get dbMessages => _dbMessages;

  get h2Style => TextStyle(color: Colors.black,fontSize: 22);
  get h3Style => TextStyle(color: Colors.black,fontSize: 18);

  Future<void> startListening() async {
    listener = DatabaseInterface().listen('rooms', manageEvent);
  }

  actionButton(text, icon, func) => ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.amberAccent),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        ),
        child: Flex(direction: Axis.horizontal, children: [
          Expanded(child: Icon(icon)),
          Expanded(
            flex: 3,
            child: AutoSizeText(
              text,
              semanticsLabel: text,
              maxLines: 1,
            ),
          ),
        ]),
        onPressed: Helper.isLoading() ? null : func,
      );

  void refresh() {
    if (mounted) setState(() {});
  }

  initState() {
    super.initState();

    Helper.startLoading(refresh);
    DatabaseInterface().init('rooms', startListening);
  }

  dispose() {
    super.dispose();
    listener.cancel();
  }

  void showErrorSnackbar(bool short) {
    SnackBar errorSnackBar = SnackBar(
      content: Text('No Internet connection!'),
      backgroundColor: Colors.red,
      duration: Duration(seconds: short ? 5 : 5000),
    );
    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
  }

  bool errorInConnectivity = false;

  void manageEvent(events) {
    if (waitingForFirstConnection) {
      if (events.toString() == '()') {
        showErrorSnackbar(false);
        errorInConnectivity = true;
      } else {
        if (errorInConnectivity) {
          errorInConnectivity = false;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
        waitingForFirstConnection = false;
        Helper.stopLoading(refresh);
      }
    }

    _dbMessages.clear();

    setState(() {
      _dbMessages.addAll(events);
    });
  }

  Future<void> _showMessage(String messageTitle, String message,
      String okCaption, Color textColor) async {
    setState(() {
      formCaption = message;
      formColor = textColor;
    });
    if (!formVisible)
      scrollController.animateTo(0,
          duration: Duration(seconds: 1), curve: Curves.linear);
  }

  void _create() async {
    Helper.startLoading(refresh);
    try {
      bool exists = await DatabaseInterface().exists('rooms', 'testRoom');
      if (exists) {
        _showMessage('ERROR', 'ERROR ON CREATE: THE RECORD ALREADY EXISTS',
            'Awww...', Colors.red);
      } else {
        await DatabaseInterface().set('rooms', 'testRoom', {
          'name': 'niceRoom',
          'game': 'checkers',
        });

        _showMessage(
            'Success!', 'Record written Successfully', 'Ok!', Colors.black);
      }
    } catch (e) {
      print('error $e');
      if (e.toString().startsWith('[cloud_firestore/unavailable]')) {
        errorInConnectivity = true;
        waitingForFirstConnection = true;
        showErrorSnackbar(true);
      }
    }

    Helper.stopLoading(refresh);
  }

  void _read() async {
    Helper.startLoading(refresh);
    try {
      Map<String, dynamic> rec =
          await DatabaseInterface().read('rooms', 'testRoom');

      if (rec.isEmpty) {
        _showMessage('Error', 'ERROR ON READ, THE RECORD WAS NOT FOUND',
            'What a pity...', Colors.red);
      } else {
        SplayTreeMap<String, dynamic> record = SplayTreeMap.from(rec);
        _showMessage(
            'Success!', 'Data found: $record', 'Got it!', Colors.black);
      }
    } catch (e) {
      if (e.toString().startsWith('[cloud_firestore/unavailable]')) {
        errorInConnectivity = true;
        waitingForFirstConnection = true;
        showErrorSnackbar(true);
      }
    }
    Helper.stopLoading(refresh);
  }

  void _update() async {
    Helper.startLoading(refresh);

    try {
      DatabaseInterface().update('rooms', 'testRoom', {
        'game': 'Chess',
      }).then((_) {
        print("result _ is $_");

        _showMessage(
            'Success!',
            'Record updated Successfully! The game is changed to Checkers',
            'Ok, thank you!',
            Colors.black);
        Helper.stopLoading(refresh);
      }).catchError((e) {
        if ((e.toString().startsWith("[cloud_firestore/not-found]")) ||
            (e.toString().startsWith("FirebaseError: No document to update"))) {
          _showMessage('ERROR', 'ERROR ON UPDATE, THE RECORD WAS NOT FOUND',
              'Cannot update? WTF!', Colors.red);
        } else {
          _showMessage(
              'ERROR', 'Error on update:${e.toString()}', 'Ok', Colors.red);
        }
        Helper.stopLoading(refresh);
      });
    } catch (e) {
      if (e.toString().startsWith('[cloud_firestore/unavailable]')) {
        errorInConnectivity = true;
        waitingForFirstConnection = true;
        showErrorSnackbar(true);
        Helper.stopLoading(refresh);
      }
    }
  }

  void _delete() async {
    Helper.startLoading(refresh);
    try {
      bool exists = await DatabaseInterface().exists('rooms', 'testRoom');

      if (!exists) {
        _showMessage('ERROR', 'ERROR ON DELETE: THE RECORD DOESN`T EXIST',
            'Can`t I delete the void?', Colors.red);
      } else {
        await DatabaseInterface().delete('rooms', 'testRoom');
        _showMessage('Success!', 'Record deleted Successfully!',
            'I will miss it!', Colors.black);
      }
    } catch (e) {
      if (e.toString().startsWith('[cloud_firestore/unavailable]')) {
        errorInConnectivity = true;
        waitingForFirstConnection = true;
        showErrorSnackbar(true);
      }
    }
    Helper.stopLoading(refresh);
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
            gradient: LinearGradient(colors: [
          Colors.white,
          Colors.white,
          Colors.white,
          Colors.cyanAccent
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              toolbarHeight: vstep,
              title: Helper.isLoading()
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

  Widget buildRoomList(List<dynamic> dbMessageList) {
    print(dbMessageList);

    final rooms = <Room>[];

    for (var r in dbMessageList) {
      try {
        final room = Room.fromJson(r);
        print('Room:$room');
        rooms.add(room);
      } catch (e) {
        print(e);
      }
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        Room r = rooms[index];
        return ListTile(
            leading: Text(r.id,style: h3Style,),
            title: Text(
              r.name,
              textAlign: TextAlign.center,
              style: h3Style,
            ),
            trailing: Text(r.game,style: h3Style,),
            tileColor: Color.fromARGB(100, 212, 100, 100)
        ,
          onTap: ()=>openRoom(r),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 8,
        );
      },
      itemCount: rooms.length,
    );
  }

  openRoom(Room r) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RoomPage(r,nameController.text)),
    );

  }

  void createNewRoom() {



  }
}
