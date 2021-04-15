import 'package:flutter/material.dart';
import 'package:roomsgame/models/room.dart';

class RoomPage extends StatefulWidget {
  Room room;
  String name;
  RoomPage(this.room,this.name);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {

  static const h3Style=TextStyle(fontSize: 30,color: Colors.black);
  static const h2Style=TextStyle(fontSize: 22,color: Colors.black);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.cyanAccent
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),

        child: Column(
          children: [
            SizedBox(height: 40),
            Center(child: Text('Room name: ${widget.room.name}',style: h3Style,)),
            SizedBox(height: 40,),
            Center(child: Text('Selected game: ${widget.room.game}',style: h2Style,)),
            SizedBox(height: 80,),
            Center(child: Text('Owner: ${widget.room.owner}',style: h2Style,)),
            SizedBox(height: 80,),
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                color: _ready?Colors.green:Color.fromARGB(100, 212, 100, 100),
                child: TextButton(onPressed: toggleReady,
                child:Text(_ready?'Waiting for game to start...':'I am ready!')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _ready=false;

  void toggleReady() {
    setState(() {
      _ready=!_ready;
    });
  }
}
