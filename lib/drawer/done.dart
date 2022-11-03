import 'package:flutter/material.dart';
import '../giver/home.dart';

class done extends StatefulWidget {
  final bool status;

  const done({Key? key, required this.status}) : super(key: key);

  @override
  State<done> createState() => _doneState();
}

class _doneState extends State<done> {

  fun()async{
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const g_home()));
  }

  @override
  void initState() {
    fun();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: widget.status
            ? Image.asset('assets/done.jpg',scale: 20,)
            : Image.asset('assets/cancle.jpg',scale: 20,),
      ),
    );
  }
}
