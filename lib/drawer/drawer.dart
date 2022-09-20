import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parking/account/account.dart';
import 'package:parking/giver/g_vehicle.dart';

class drawer extends StatelessWidget {
  final bool type;
  const drawer({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(account.fname_! + " " + account.lname_!),
                accountEmail: Text(account.email_!),
                // currentAccountPicture: CircleAvatar(
                //   backgroundColor: Colors.white,
                //   child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-KU4nchvUY3YAlh3M2Gp_xF3V6CE1UMbm09uiM6YM&s",width: 50),
                // ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text("Home"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              !type
                  ? ListTile(
                      leading: const Icon(Icons.update),
                      title: const Text("Update Data"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => g_vehicle(
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      update: true,
                                    )));
                      },
                    )
                  : Container()
            ],
          ),
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.contacts),
                title: const Text("Contact Us"),
                onTap: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
