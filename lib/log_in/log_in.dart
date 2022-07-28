import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parking/account/account.dart';
import 'package:parking/giver/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class log_in extends StatefulWidget {
  @override
  State<log_in> createState() => _log_inState();
}

class _log_inState extends State<log_in> {
  final _key = GlobalKey<FormState>();
  bool pressed = false;
  String? email;
  String? pass;
  String? num;

  gohome() async {
    if (_key.currentState!.validate()) {
      pressed = true;
      setState(() {});
      try {
        SharedPreferences add = await SharedPreferences.getInstance();
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email!, password: pass!);
        await FirebaseFirestore.instance
            .collection("userdata")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get()
            .then((value) => {
                  account.email_ = value.data()!['email'],
                  account.num_ = value.data()!['num'],
                  account.pass_ = value.data()!['pass'],
                  account.fname_ = value.data()!['fname'],
                  account.lname_ = value.data()!['lname'],
                  add.setString("email", account.email_!),
                  add.setString("num", account.num_!),
                  add.setString("pass", account.pass_!),
                  add.setString("fname", account.fname_!),
                  add.setString("lname", account.lname_!),
                });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => g_home()));
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
        Fluttertoast.showToast(
            msg: "Something Wrong,please try after some time");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Image.asset(
              'assets/logo_.jpg',
              scale: 2.5,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Login Now',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Please enter the Details below to continue",
              style: TextStyle(color: Colors.grey, fontSize: 13),
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
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(
                              Icons.person_rounded,
                              color: Colors.grey,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      SizedBox(
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
                          if (value.length < 7) {
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
                            labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black)),
                            prefixIcon: Icon(
                              Icons.security,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            gohome();
                          },
                          child: Container(
                            width: 100,
                            height: 50,
                            child: pressed
                                ? CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Login',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 78, 120, 198),
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
