import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:parking/account/account.dart';
import 'package:parking/taker/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../giver/home.dart';

class log_in extends StatefulWidget {
  final bool choise;

  const log_in({Key? key, required this.choise}) : super(key: key);

  @override
  State<log_in> createState() => _log_inState();
}

class _log_inState extends State<log_in> {
  Color color = HexColor("#4f79c6");
  final _key = GlobalKey<FormState>();
  bool pressed = false;
  String? email;
  String? pass;
  String? num;

  gohome() async {
    if (_key.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      setState(() {
        pressed = true;
      });
      if (await fun.checkInternet()) {
        try {
          String x;
          SharedPreferences add = await SharedPreferences.getInstance();
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email!, password: pass!);
          await FirebaseFirestore.instance
              .collection(widget.choise ? "userdata" : "user_data")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .get()
              .then((value) => {
            account.email_ = value.data()!['email'],
            account.num_ = value.data()!['num'],
            account.pass_ = value.data()!['pass'],
            account.fname_ = value.data()!['fname'],
            account.lname_ = value.data()!['lname'],
            account.user_ = value.data()!['user'],
            if (account.user_ == false)
              {
                x = value.data()!['list'],
                account.list_ = x.split(","),
                add.setStringList('list', account.list_!)
              },
            add.setString("email", account.email_!),
            add.setString("num", account.num_!),
            add.setString("pass", account.pass_!),
            add.setString("fname", account.fname_!),
            add.setString("lname", account.lname_!),
            add.setBool('user', account.user_!),
          });
          if (account.user_!) {
            await fun.get_marker();
            await fun.set_marker();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const t_home()));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const g_home()));
          }
        } on FirebaseAuthException catch (e) {
          pressed = false;
          setState(() {});
          switch (e.code) {
            case "invalid-email":
              Fluttertoast.showToast(msg: 'invalid-email');
              break;
            case "wrong-password":
              Fluttertoast.showToast(msg: 'Wrong-password');
              break;
            case "weak-password":
              Fluttertoast.showToast(msg: 'Weak-password');
              break;
          }
        } catch (e) {
          pressed = false;
          setState(() {});
          FirebaseAuth.instance.signOut();
          Fluttertoast.showToast(msg: e.toString());
          Fluttertoast.showToast(
              msg: "Something Wrong,please try after some time");
        }
      } else {
        Fluttertoast.showToast(msg: "You Your Internet connection");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Log In"),
        elevation: 0,
        backgroundColor: color,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Hero(
              tag: "logo",
              child: Image.asset(
                'assets/logo_.png',
                scale: 2.2,
              ),
            ),
            const Text(
              'Login Now',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Please enter the Details below to continue",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter email";
                          }
                          if (!value.contains("@") || !value.contains(".")) {
                            return "please enter valid email";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            focusColor: Colors.grey,
                            fillColor: Colors.grey,
                            hintText: "email",
                            labelText: "email",
                            labelStyle: const TextStyle(color: Colors.black),
                            prefixIcon: const Icon(
                              Icons.person_rounded,
                              color: Colors.grey,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.black)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          pass = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "please enter password";
                          }
                          if (value.length < 9) {
                            return "password contain 8 characters";
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            focusColor: Colors.grey,
                            fillColor: Colors.grey,
                            hintText: "password",
                            labelText: "password",
                            labelStyle: const TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.black)),
                            prefixIcon: const Icon(
                              Icons.security,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      pressed
                          ? SpinKitCircle(
                        color: color,
                        size: 50.0,
                      )
                          : Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            gohome();
                          },
                          child: Container(
                            width: 100,
                            height: 50,
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
