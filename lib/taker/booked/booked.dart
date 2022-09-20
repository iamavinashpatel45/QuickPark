import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';

class booked extends StatefulWidget {
  const booked({Key? key}) : super(key: key);

  @override
  State<booked> createState() => _bookedState();
}

class _bookedState extends State<booked> {
  Color color = HexColor("#4f79c6");
  bool go = true;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  DatabaseReference db = FirebaseDatabase.instance
      .ref("booking(user)/" + FirebaseAuth.instance.currentUser!.uid);

  _callNumber(String num) async {
    await FlutterPhoneDirectCaller.callNumber(num);
  }

  delete_data(String key) async {
    DatabaseReference db_delete = FirebaseDatabase.instance.ref(
        "booking(user)/" + FirebaseAuth.instance.currentUser!.uid + "/" + key);
    await db_delete.remove().then((value) => () {
          go = false;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booked Slot"),
        backgroundColor: color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FirebaseAnimatedList(
          shrinkWrap: true,
          defaultChild: Center(
            child: SpinKitCubeGrid(
              color: color,
              size: 50.0,
            ),
          ),
          query: db,
          itemBuilder: (context, snapshot, animation, index) {
            go = true;
            DateTime.now().isBefore(
                    DateTime.parse(snapshot.child('ldate').value.toString()))
                ? () {}
                : delete_data(snapshot.key!);
            return go
                ? Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  VerticalDivider(
                                    color: color,
                                    thickness: 8,
                                  ),
                                  Expanded(
                                      child: Text(
                                    snapshot
                                        .child('address')
                                        .value
                                        .toString(),
                                    style: TextStyle(fontSize: 18),
                                  )),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 10, right: 20),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'BASIC PASS',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: color,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const Text(
                                              'SINGLE ENTARY AND EXIT',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  snapshot
                                                      .child('vehical_path')
                                                      .value
                                                      .toString(),
                                                  scale: 18,
                                                ),
                                                Text(snapshot
                                                    .child('type')
                                                    .value
                                                    .toString()),
                                              ],
                                            ),
                                            Text(
                                              '₹ ' +
                                                  snapshot
                                                      .child('amount')
                                                      .value
                                                      .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: color,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          MyBullet(),
                                          const SizedBox(
                                              width: 50,
                                              child: Text(" From")),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              child: Text(
                                                snapshot
                                                    .child('atime')
                                                    .value
                                                    .toString(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Text(" •"),
                                      const Text(" •"),
                                      Row(
                                        children: [
                                          MyBullet(),
                                          const SizedBox(
                                              width: 50,
                                              child: Text(" Until")),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              child: Text(
                                                snapshot
                                                    .child('ltime')
                                                    .value
                                                    .toString(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Text("From " +
                                  //     snapshot.child('atime').value.toString()),
                                  // Text("Until " +
                                  //     snapshot.child('ltime').value.toString()),
                                  InkWell(
                                    onTap: () {
                                      _callNumber(snapshot
                                          .child('num')
                                          .value
                                          .toString());
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(Icons.phone),
                                        Text(snapshot
                                            .child('num')
                                            .value
                                            .toString())
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container();
          },
        ),
      ),
    );
  }
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.0,
      width: 1.0,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}
