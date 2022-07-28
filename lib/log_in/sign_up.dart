import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parking/account/account.dart';
import 'package:parking/giver/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class sign_up extends StatefulWidget {
  const sign_up({Key? key}) : super(key: key);

  @override
  State<sign_up> createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
  final _key = GlobalKey<FormState>();
  bool pressed = false;
  String? email;
  String? num;
  String? pass;
  String? fname;
  String? lname;

  gohome() async {
    if (_key.currentState!.validate()) {
      setState(() {
        pressed = true;
      });
      try {
        SharedPreferences add = await SharedPreferences.getInstance();
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: pass!);
        await FirebaseFirestore.instance
            .collection("userdata")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .set(account(
                    email: email,
                    num: num,
                    fname: fname,
                    lname: lname,
                    pass: pass)
                .toJson())
            .then((value) => {
                  account.email_ = email,
                  account.num_ = num,
                  account.pass_ = pass,
                  account.fname_ = fname,
                  account.lname_ = lname,
                  add.setString("email", email!),
                  add.setString("num", num!),
                  add.setString("pass", pass!),
                  add.setString("fname", fname!),
                  add.setString("lname", lname!),
                });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => g_home()));
      } on FirebaseAuthException catch (e) {
        setState(() {
          pressed = false;
        });
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
          case "email-already-in-use":
            Fluttertoast.showToast(msg: 'email-already-in-use');
            break;
        }
      } catch (e) {
        try {
          await FirebaseFirestore.instance
              .collection("userdata")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .delete();
        } catch (e) {}
        if (FirebaseAuth.instance.currentUser!.uid != null) {
          FirebaseAuth.instance.currentUser!.delete();
        }
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
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 10,
            ),
            Image.asset(
              'assets/logo_.jpg',
              scale: 2.5,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Register with QuickPark',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Form(
              key: _key,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        fname = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          focusColor: Colors.grey,
                          fillColor: Colors.grey,
                          hintText: "First name",
                          labelText: "First name",
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
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        lname = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          focusColor: Colors.grey,
                          fillColor: Colors.grey,
                          hintText: "Last name",
                          labelText: "Last name",
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
                      height: 10,
                    ),
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
                            Icons.email_rounded,
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
                      height: 10,
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
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        num = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter number";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          focusColor: Colors.grey,
                          fillColor: Colors.grey,
                          hintText: "phone number",
                          labelText: "phone number",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.phone,
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
                      height: 10,
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
