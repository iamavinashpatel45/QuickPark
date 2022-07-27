import 'package:flutter/material.dart';

class g_home extends StatefulWidget {
  const g_home({Key? key}) : super(key: key);

  @override
  State<g_home> createState() => _g_homeState();
}

class _g_homeState extends State<g_home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Center(child: Text("Map")),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              child: Center(
                child: Icon(Icons.menu),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              child: Row(
                children: [
                  Icon(Icons.ev_station,color: Colors.amber,),
                  Text("Ev Parking"),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
