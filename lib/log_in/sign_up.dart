import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:parking/account/account.dart';
import 'package:parking/giver/g_vehicle.dart';
import 'package:parking/taker/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class sign_up extends StatefulWidget {
  final bool choise;

  const sign_up({Key? key, required this.choise}) : super(key: key);

  @override
  State<sign_up> createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
  Color color = HexColor("#4f79c6");
  final _key = GlobalKey<FormState>();
  bool pressed = false;
  String? email;
  String? num;
  String? pass;
  String? fname;
  String? lname;

  gohome() async {
    if (_key.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      setState(() {
        pressed = true;
      });
      if (await fun.checkInternet()) {
        try {
          SharedPreferences add = await SharedPreferences.getInstance();
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email!, password: pass!);
          await FirebaseFirestore.instance
              .collection(widget.choise ? "userdata" : "user_data")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .set(account(
                      email: email,
                      num: num,
                      fname: fname,
                      lname: lname,
                      pass: pass,
                      user: widget.choise)
                  .toJson())
              .then((value) => {
                    account.email_ = email,
                    account.num_ = num,
                    account.pass_ = pass,
                    account.fname_ = fname,
                    account.lname_ = lname,
                    account.user_ = widget.choise,
                    add.setString("email", email!),
                    add.setString("num", num!),
                    add.setString("pass", pass!),
                    add.setString("fname", fname!),
                    add.setString("lname", lname!),
                    add.setBool('user', widget.choise),
                  });
          if (account.user_!) {
            await fun.get_marker();
            await fun.set_marker();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const t_home()));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => g_vehicle(
                          uid: FirebaseAuth.instance.currentUser?.uid,
                          update: false,
                        )));
          }
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
        title: const Text("Register"),
        //iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: color,
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
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Register with QuickPark',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _key,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 15,
                ),
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
                          labelStyle: const TextStyle(color: Colors.black),
                          prefixIcon: const Icon(
                            Icons.email_rounded,
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
                          labelStyle: const TextStyle(color: Colors.black),
                          prefixIcon: const Icon(
                            Icons.phone,
                            color: Colors.grey,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                              const BorderSide(color: Colors.black)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
