import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:parking/account/account.dart';
import 'package:parking/giver/g_vehicle.dart';
import 'package:parking/log_in/choice.dart';
import '../taker/booked/booked.dart';
import 'done.dart';

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
                  ? Column(
                      children: [
                        ListTile(
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
                        ),
                        ListTile(
                          leading: const Icon(Icons.update),
                          title: const Text("Scan Qr Code"),
                          onTap: () async {
                            bool quick = false;
                            String result =
                                await FlutterBarcodeScanner.scanBarcode(
                                    '#ff6666', 'Cancel', true, ScanMode.QR);
                            for (int i = 0; i < account.qr_data.length; i++) {
                              if (account.qr_data[i] == result) {
                                quick = true;
                                break;
                              }
                            }
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => done(
                                          status: quick,
                                        )));
                          },
                        ),
                      ],
                    )
                  : ListTile(
                      leading: const Icon(Icons.my_library_books),
                      title: const Text("My Booking"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const booked()));
                      },
                    )
            ],
          ),
          Column(
            children: [
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Log Out"),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => choice(choise: true)));
                },
              ),
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
