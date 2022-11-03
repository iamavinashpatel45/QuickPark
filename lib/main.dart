import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:parking/account/account.dart';
import 'package:parking/taker/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'giver/home.dart';
import 'log_in/choice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const myapp());
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
      theme: ThemeData(
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.transparent),
      ),
      home: const splash(),
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
    if (await fun.checkInternet()) {
      if (await FirebaseAuth.instance.currentUser == null) {
        Navigator.pushReplacement(
            context,
            PageTransition(
              child: const choice(
                choise: true,
              ),
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 500),
            ));
      } else {
        SharedPreferences get = await SharedPreferences.getInstance();
        account.email_ = get.getString("email");
        account.num_ = get.getString("num");
        account.pass_ = get.getString("pass");
        account.fname_ = get.getString("fname");
        account.lname_ = get.getString("lname");
        account.user_ = get.getBool("user");
        if (account.user_!) {
          await fun.get_marker();
          await fun.set_marker();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const t_home()));
        } else {
          account.list_ = get.getStringList("list");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const g_home()));
        }
      }
    } else {
      Fluttertoast.showToast(msg: "You Your Internet connection");
    }
  }

  getdata() async {
    var json = await rootBundle.loadString('assets/vehicles/vehicles.json');
    account.data_vehicle = jsonDecode(json);
  }

  @override
  void initState() {
    getdata();
    userdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/logo_.png",scale: 1.8,),
      ),
    );
  }
}
