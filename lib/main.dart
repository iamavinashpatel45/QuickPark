import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parking/account/account.dart';
import 'package:parking/giver/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'log_in/choice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(myapp());
}

class myapp extends StatefulWidget {
  const myapp({Key? key}) : super(key: key);

  @override
  State<myapp> createState() => _myappState();
}

class _myappState extends State<myapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: splash(),
    );
  }
}

class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  userdata() async {
    if (FirebaseAuth.instance.currentUser == null) {
      SharedPreferences get = await SharedPreferences.getInstance();
      account.email_ = get.getString("email");
      account.num_ = get.getString("num");
      account.pass_ = get.getString("pass");
      account.fname_ = get.getString("fname");
      account.lname_ = get.getString("lname");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => choice()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => g_home()));
    }
  }

  @override
  void initState() {
    userdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/logo_.jpg"),
      ),
    );
  }
}
