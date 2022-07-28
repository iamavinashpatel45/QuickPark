import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class slindingup extends StatefulWidget {
  @override
  State<slindingup> createState() => _slindingupState();
}

class _slindingupState extends State<slindingup> {
  DateTime time=DateTime.now();
  String? timestr;

  settime(){
    if(time.hour<12)
      {
        timestr='Good Morning';
      }
    else if(time.hour<17)
      {
        timestr='Good Afternoon';
      }
    else
      {
        timestr='Good Evening';
      }
  }

  @override
  void initState() {
    settime();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      collapsed: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Icon(
            Icons.keyboard_arrow_up,
            size: 40,
          ),
        ],
      ),
      panel: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Text(timestr!),
        ],
      ),
    );
  }
}
