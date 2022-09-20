import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:parking/account/account.dart';
import 'home.dart';

class g_vehicle extends StatefulWidget {
  final String? uid;
  final bool update;

  const g_vehicle({Key? key, required this.uid, required this.update})
      : super(key: key);

  @override
  State<g_vehicle> createState() => _g_vehicleState();
}

class _g_vehicleState extends State<g_vehicle> {
  Color color = HexColor("#4f79c6");
  bool press = false;
  bool cir = false;
  bool press_but = false;
  LocationData? livelocation;
  LatLng? latLng_loacation;
  String? address;
  final _key = GlobalKey<FormState>();
  bool textfield = false;
  List<bool> select = [false, false, false, false, false, false];
  List<List> vehicle = [
    [1, 0],
    [2, 0],
    [3, 0],
    [4, 0],
    [5, 0],
    [6, 0],
  ];

  gohome() async {
    if (_key.currentState!.validate() && livelocation != null) {
      FocusScope.of(context).unfocus();
      setState(() {
        press_but = true;
      });
      try {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        await FirebaseFirestore.instance
            .collection("user_data")
            .doc(uid)
            .update(account(
                    email: account.email_,
                    num: account.num_,
                    fname: account.fname_,
                    lname: account.lname_,
                    pass: account.pass_,
                    user: false,
                    l_1: latLng_loacation!.latitude.toString(),
                    l_2: latLng_loacation!.longitude.toString(),
                    list: vehicle.toString())
                .toJson())
            .then((value) => {});
        for (int i = 0; i < 6; i++) {
          if (vehicle[i][1] != 0) {
            String x = "v_" + (i + 1).toString();
            await FirebaseFirestore.instance
                .collection(x)
                .doc(uid)
                .set(vehicle_data(
                        uid: uid,
                        location_1: latLng_loacation!.latitude.toString(),
                        location_2: latLng_loacation!.longitude.toString(),
                        num: int.parse(vehicle[i][1]))
                    .toJson())
                .then((value) => {});
          }
        }
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const g_home()));
      } on FirebaseAuthException catch (e) {
        setState(() {
          press_but = false;
        });
      } catch (e) {
        setState(() {
          press_but = false;
        });
        Fluttertoast.showToast(
            msg: "Something Wrong,please try after some time");
      }
    }
  }

  Future getlocation() async {
    Location location = Location();
    await location.getLocation().then((location) => {livelocation = location});
    latLng_loacation =
        LatLng(livelocation!.latitude!, livelocation!.longitude!);
    address = await fun.get_address(latLng_loacation!);
    setState(() {
      press = true;
      cir = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "Enter your details",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Stack(children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: account.data_vehicle!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: InkWell(
                              onTap: () {
                                if (select[index] == true) {
                                  select[index] = false;
                                  vehicle[index] = [
                                    account.data_vehicle![index]['id'],
                                    0
                                  ];
                                } else {
                                  select[index] = true;
                                }
                                setState(() {});
                              },
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.blue,
                                          width: select[index] ? 2 : 0)),
                                  child: ListTile(
                                    leading: Image.asset(
                                        account.data_vehicle![index]['image']),
                                    title: Text(
                                      account.data_vehicle![index]['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          account.data_vehicle![index]['desc'],
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        select[index]
                                            ? Row(
                                                children: [
                                                  const Text(
                                                    "Enter Capacity :: ",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 25,
                                                      width: 30,
                                                      child: TextFormField(
                                                        onChanged: (value) {
                                                          vehicle[index] = [
                                                            account.data_vehicle![
                                                                index]['id'],
                                                            value
                                                          ];
                                                        },
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return "please enter vehicle number";
                                                          }
                                                          return null;
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Your Parking Place Location",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  press == false
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              getlocation();
                              cir = true;
                            });
                          },
                    child: const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text("Tap to add your live Location"),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(address!),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  press_but
                      ? Center(
                          child: SpinKitCircle(
                            color: color,
                            size: 50.0,
                          ),
                        )
                      : Center(
                          child: Material(
                            child: InkWell(
                              onTap: () {
                                gohome();
                              },
                              child: Container(
                                width: 150,
                                height: 50,
                                child: Text(
                                  widget.update ? 'Update' : 'Add Details',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 78, 120, 198),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
          Positioned(
              child: cir == true
                  ? Center(
                      child: SpinKitCubeGrid(
                        color: color,
                        size: 50.0,
                      ),
                    )
                  : Container())
        ]));
  }
}
