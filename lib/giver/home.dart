import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:parking/account/account.dart';
import 'package:parking/drawer/drawer.dart';
import 'package:ticket_material/ticket_material.dart';

class g_home extends StatefulWidget {
  const g_home({Key? key}) : super(key: key);

  @override
  State<g_home> createState() => _g_homeState();
}

class _g_homeState extends State<g_home> {
  Color color = HexColor("#4f79c6");
  bool go = true;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  DatabaseReference db = FirebaseDatabase.instance
      .ref("booking/" + FirebaseAuth.instance.currentUser!.uid);

  _callNumber(String num) async {
    await FlutterPhoneDirectCaller.callNumber(num);
  }

  delete_data(String key) async {
    DatabaseReference db_delete = FirebaseDatabase.instance
        .ref("booking/" + FirebaseAuth.instance.currentUser!.uid + "/" + key);
    await db_delete.remove().then((value) => () {
          go = false;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const drawer(
        type: false,
      ),
      appBar: AppBar(
        title: const Text('booking'),
        backgroundColor: HexColor("#4f79c6"),
        elevation: 0,
      ),
      body: FirebaseAnimatedList(
        shrinkWrap: true,
        query: db,
        defaultChild: Center(
          child: SpinKitCubeGrid(
            color: HexColor("#4f79c6"),
            size: 50.0,
          ),
        ),
        itemBuilder: (context, snapshot, animation, index) {
          go = true;
          account.qr_data
              .add(snapshot.child('random').value.toString());
          DateTime.now().isBefore(
                  DateTime.parse(snapshot.child('ldate').value.toString()))
              ? () {

                }
              : delete_data(snapshot.key!);
          return go
              ? Card(
            elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TicketMaterial(
                      height: 220,
                      radiusCircle: 6,
                      leftChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const VerticalDivider(
                                  color: Colors.black,
                                  thickness: 10,
                                ),
                                Expanded(
                                    child: Text(
                                  snapshot.child('address').value.toString(),
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                )),
                              ],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 15, top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'BASIC PASS',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Text(
                                    'SINGLE ENTARY AND EXIT',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                          width: 50,
                                          child: Text(
                                            " From",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          child: Text(
                                            snapshot
                                                .child('atime')
                                                .value
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Text(
                                    " •",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const Text(
                                    " •",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                          width: 50,
                                          child: Text(
                                            " Until",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          child: Text(
                                            snapshot
                                                .child('ltime')
                                                .value
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ))
                        ],
                      ),
                      rightChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            snapshot.child('vehical_path').value.toString(),
                            scale: 7,
                          ),
                          Text(
                            snapshot.child('type').value.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            "₹" + snapshot.child('amount').value.toString(),
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          const Text(
                            "(Pay At Location)",
                            style: TextStyle(
                                fontSize: 8,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                              onTap: () {
                                _callNumber(
                                    snapshot.child('num').value.toString());
                              },
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Container(
                                    height: 40,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white,
                                            spreadRadius: 2,
                                          ),
                                          BoxShadow(
                                            color: Colors.white,
                                          ),
                                        ]),
                                    child: const Icon(
                                      Icons.phone,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "Call",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      colorBackground: color),
                )
              : Container();
        },
      ),
    );
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.0,
      width: 10.0,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}
