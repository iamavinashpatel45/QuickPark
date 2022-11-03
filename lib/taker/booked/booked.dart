import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flipcard/gesture_flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ticket_material/ticket_material.dart';

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
                ? Column(
                    children: [
                      Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GestureFlipCard(
                          animationDuration: const Duration(milliseconds: 300),
                          axis: FlipAxis.vertical,
                          frontWidget: TicketMaterial(
                              height: 220,
                              radiusCircle: 6,
                              leftChild: leftside_up(
                                snapshot: snapshot,
                              ),
                              rightChild: rightside(
                                snapshot: snapshot,
                              ),
                              colorBackground: color),
                          backWidget: TicketMaterial(
                              height: 220,
                              radiusCircle: 6,
                              leftChild: leftside_back(snapshot: snapshot.child('random').value.toString(),),
                              rightChild: rightside(
                                snapshot: snapshot,
                              ),
                              colorBackground: color),
                        ),
                      ),
                      // Card(
                      //   elevation: 10,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       border: Border.all(
                      //         color: Colors.black,
                      //       ),
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(vertical: 10),
                      //       child: Column(
                      //         children: [
                      //           IntrinsicHeight(
                      //             child: Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 VerticalDivider(
                      //                   color: color,
                      //                   thickness: 8,
                      //                 ),
                      //                 Expanded(
                      //                     child: Text(
                      //                   snapshot
                      //                       .child('address')
                      //                       .value
                      //                       .toString(),
                      //                   style: const TextStyle(
                      //                     fontSize: 18,
                      //                   ),
                      //                 )),
                      //               ],
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: const EdgeInsets.only(left: 18),
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 Padding(
                      //                   padding: const EdgeInsets.only(
                      //                       top: 5, bottom: 10, right: 20),
                      //                   child: Row(
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.center,
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.spaceBetween,
                      //                     children: [
                      //                       Column(
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.start,
                      //                         children: [
                      //                           Text(
                      //                             'BASIC PASS',
                      //                             style: TextStyle(
                      //                               fontWeight: FontWeight.w500,
                      //                               color: color,
                      //                               fontSize: 18,
                      //                             ),
                      //                           ),
                      //                           const Text(
                      //                             'SINGLE ENTARY AND EXIT',
                      //                             style: TextStyle(
                      //                               fontWeight: FontWeight.w400,
                      //                               fontSize: 12,
                      //                             ),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                       Column(
                      //                         children: [
                      //                           Row(
                      //                             children: [
                      //                               Image.asset(
                      //                                 snapshot
                      //                                     .child('vehical_path')
                      //                                     .value
                      //                                     .toString(),
                      //                                 scale: 18,
                      //                               ),
                      //                               Text(snapshot
                      //                                   .child('type')
                      //                                   .value
                      //                                   .toString()),
                      //                             ],
                      //                           ),
                      //                           Text(
                      //                             '₹ ' +
                      //                                 snapshot
                      //                                     .child('amount')
                      //                                     .value
                      //                                     .toString(),
                      //                             style: TextStyle(
                      //                               fontWeight: FontWeight.w500,
                      //                               color: color,
                      //                               fontSize: 18,
                      //                             ),
                      //                           ),
                      //                         ],
                      //                       )
                      //                     ],
                      //                   ),
                      //                 ),
                      //                 Column(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: [
                      //                     Row(
                      //                       children: [
                      //                         MyBullet(),
                      //                         const SizedBox(
                      //                             width: 50,
                      //                             child: Text(" From")),
                      //                         Container(
                      //                           decoration: BoxDecoration(
                      //                             color: Colors.grey[300],
                      //                             border: Border.all(
                      //                               color: Colors.black,
                      //                             ),
                      //                             borderRadius:
                      //                                 BorderRadius.circular(10),
                      //                           ),
                      //                           child: Padding(
                      //                             padding: const EdgeInsets
                      //                                     .symmetric(
                      //                                 horizontal: 8,
                      //                                 vertical: 4),
                      //                             child: Text(
                      //                               snapshot
                      //                                   .child('atime')
                      //                                   .value
                      //                                   .toString(),
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                     const Text(" •"),
                      //                     const Text(" •"),
                      //                     Row(
                      //                       children: [
                      //                         MyBullet(),
                      //                         const SizedBox(
                      //                             width: 50,
                      //                             child: Text(" Until")),
                      //                         Container(
                      //                           decoration: BoxDecoration(
                      //                             color: Colors.grey[300],
                      //                             border: Border.all(
                      //                               color: Colors.black,
                      //                             ),
                      //                             borderRadius:
                      //                                 BorderRadius.circular(10),
                      //                           ),
                      //                           child: Padding(
                      //                             padding: const EdgeInsets
                      //                                     .symmetric(
                      //                                 horizontal: 8,
                      //                                 vertical: 4),
                      //                             child: Text(
                      //                               snapshot
                      //                                   .child('ltime')
                      //                                   .value
                      //                                   .toString(),
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ],
                      //                 ),
                      //                 // Text("From " +
                      //                 //     snapshot.child('atime').value.toString()),
                      //                 // Text("Until " +
                      //                 //     snapshot.child('ltime').value.toString()),
                      //                 InkWell(
                      //                   onTap: () {
                      //                     _callNumber(snapshot
                      //                         .child('num')
                      //                         .value
                      //                         .toString());
                      //                   },
                      //                   child: Row(
                      //                     children: [
                      //                       const Icon(Icons.phone),
                      //                       Text(snapshot
                      //                           .child('num')
                      //                           .value
                      //                           .toString())
                      //                     ],
                      //                   ),
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  )
                : Container();
          },
        ),
      ),
    );
  }
}

class leftside_back extends StatefulWidget {
  final String snapshot;

  const leftside_back({Key? key, required this.snapshot}) : super(key: key);
  @override
  State<leftside_back> createState() => _leftside_backState();
}

class _leftside_backState extends State<leftside_back> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: QrImage(
        data: widget.snapshot,
        foregroundColor: Colors.black87,
        embeddedImage: const AssetImage('assets/logo__.png'),
        embeddedImageStyle: QrEmbeddedImageStyle(
          size: const Size(80, 80),
        ),
      ),
    );
  }
}


class leftside_up extends StatefulWidget {
  final DataSnapshot snapshot;

  const leftside_up({Key? key, required this.snapshot}) : super(key: key);

  @override
  State<leftside_up> createState() => _leftside_upState();
}

class _leftside_upState extends State<leftside_up> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
                widget.snapshot.child('address').value.toString(),
                style: const TextStyle(fontSize: 18, color: Colors.white),
              )),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 15, top: 12),
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
                          style: TextStyle(color: Colors.white),
                        )),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Text(
                          widget.snapshot.child('atime').value.toString(),
                          style: const TextStyle(color: Colors.white),
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
                          style: TextStyle(color: Colors.white),
                        )),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Text(
                          widget.snapshot.child('ltime').value.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ))
      ],
    );
  }
}

class rightside extends StatefulWidget {
  final DataSnapshot snapshot;

  const rightside({Key? key, required this.snapshot}) : super(key: key);

  @override
  State<rightside> createState() => _rightsideState();
}

class _rightsideState extends State<rightside> {
  _callNumber(String num) async {
    await FlutterPhoneDirectCaller.callNumber(num);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          widget.snapshot.child('vehical_path').value.toString(),
          scale: 7,
        ),
        Text(
          widget.snapshot.child('type').value.toString(),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 7,
        ),
        Text(
          "₹" + widget.snapshot.child('amount').value.toString(),
          style: const TextStyle(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700),
        ),
        const Text(
          "(Pay At Location)",
          style: TextStyle(
              fontSize: 8, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        InkWell(
            onTap: () {
              _callNumber(widget.snapshot.child('num').value.toString());
            },
            child: Row(
              children: [
                const SizedBox(
                  width: 2,
                ),
                Container(
                  height: 40,
                  decoration:
                      const BoxDecoration(shape: BoxShape.circle, boxShadow: [
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
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            )),
        InkWell(
          onTap: () {
            MapsLauncher.launchQuery(
                widget.snapshot.child('address').value.toString());
          },
          child: Row(
            children: [
              const SizedBox(
                width: 2,
              ),
              Container(
                height: 40,
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.white,
                  ),
                ]),
                child: const Icon(
                  Icons.map,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                "Map",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        )
      ],
    );
  }
}
