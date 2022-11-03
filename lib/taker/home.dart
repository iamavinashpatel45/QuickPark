import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';
import 'package:parking/account/account.dart';
import 'package:parking/drawer/drawer.dart';
import 'package:parking/taker/vehicle/t_vehicle.dart';
import 'package:upi_india/upi_india.dart';
import '../taker/datetime_picker/datetime_picker_arrive.dart';
import 'booking_details.dart';

class t_home extends StatefulWidget {
  const t_home({Key? key}) : super(key: key);

  @override
  State<t_home> createState() => _t_homeState();
}

class _t_homeState extends State<t_home> {
  final GlobalKey<ScaffoldState> _drawerscaffoldkey = new GlobalKey<ScaffoldState>();
  Color color = HexColor("#4f79c6");
  GoogleMapController? _controller;
  LocationData? livelocation;
  bool progressbar = false;
  String vehicle_type = 'assets/vehicles/car.png';
  List<Marker>? marker;

  go_on_marker(LatLng latLng, Marker marker) async {
    _controller?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 17)));
    booking_details.address = await fun.get_address(latLng);
    booking_details.marker = marker;
    setState(() {
      booking_details.next = latLng;
    });
  }

  add_ontap(List<Marker> list) {
    int x = list.length;
    for (int i = 0; i < x; i++) {
      list[i].onTap = () {
        go_on_marker(list[i].position, list[i]);
      };
    }
  }

  Future go_on_liveloaction() async {
    setState(() {
      progressbar = true;
    });
    Location location = Location();
    await location.getLocation().then((location) => {livelocation = location});
    setState(() {
      _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(livelocation!.latitude!, livelocation!.longitude!),
          zoom: 15)));
      progressbar = false;
    });
  }

  getupiapps() {
    UpiIndia _upiIndia = UpiIndia();
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        booking_details.apps = value;
      });
    }).catchError((e) {
      booking_details.apps = [];
    });
  }

  Future getlocation() async {
    marker = account.m_1;
    add_ontap(marker!);
    getupiapps();
    Location location = Location();
    await location.getLocation().then((location) => {
          setState(() {
            livelocation = location;
            account.livelocation=location;
          })
        });
  }

  set_vehicle() {
    if (booking_details.vehicle_type == 1) {
      vehicle_type = 'assets/vehicles/car.png';
      marker = account.m_1;
    } else if (booking_details.vehicle_type == 2) {
      vehicle_type = 'assets/vehicles/bike.png';
      marker = account.m_2;
    } else if (booking_details.vehicle_type == 3) {
      vehicle_type = 'assets/vehicles/van.png';
      marker = account.m_3;
    } else if (booking_details.vehicle_type == 4) {
      vehicle_type = 'assets/vehicles/bus.png';
      marker = account.m_4;
    } else if (booking_details.vehicle_type == 5) {
      vehicle_type = 'assets/vehicles/s_truck.png';
      marker = account.m_5;
    } else if (booking_details.vehicle_type == 6) {
      vehicle_type = 'assets/vehicles/b_truck.png';
      marker = account.m_6;
    }
    add_ontap(marker!);
  }

  @override
  void initState() {
    getlocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return livelocation == null
        ? Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/logo_.png",scale: 1.8,),
                  const SizedBox(
                    height: 10,
                  ),
                  SpinKitThreeBounce(
                    color: color,
                    size: 50.0,
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
      key: _drawerscaffoldkey,
            drawer: const drawer(
              type: true,
            ),
            bottomSheet: Container(
              height: 150,
              color: Colors.black.withOpacity(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                    Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => t_vehicle()))
                              .then((value) => {
                                    setState(() {
                                      set_vehicle();
                                    })
                                  });
                        },
                  child: Container(
                    height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black, width: 0.5)),
                          child: Center(
                            child: Image.asset(vehicle_type),
                          ),
                        ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    go_on_liveloaction();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                          width: 0.5,
                        )),
                    child: Center(
                      child: Icon(
                        Icons.my_location,
                        color: color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            booking_details.next != null
                ? Material(
              elevation: 10,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                  border: Border.all(color: Colors.black),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width:
                        MediaQuery.of(context).size.width / 2,
                        child: Text(
                          booking_details.address!,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: color,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                                          context,
                                          PageTransition(
                                            alignment: Alignment.centerLeft,
                                            child:
                                                const datetime_picker_arrive(),
                                            type: PageTransitionType.size,
                                            duration:
                                                const Duration(milliseconds: 500),
                                          ));
                                    },
                        child: Container(
                          height: 45,
                          width: 120,
                          decoration: BoxDecoration(
                              color: color,
                              borderRadius:
                              BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              )),
                          child: const Center(
                            child: Text(
                              'Next',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
                : Container(
              height: 0,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            // onTap: (LatLng l) {
            //   print(fun.get_address(l));
            // },
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
        markers: marker!.map((e) => e).toSet(),
        initialCameraPosition: CameraPosition(
          target: LatLng(livelocation!.latitude!,
              livelocation!.longitude!),
          zoom: 15),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
            progressbar == true
        ? Positioned(
      top: 150,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          width: MediaQuery.of(context).size.width - 30,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 0.5,
                          )),
                      child: Center(
                        child: Text(
                          "Loading,Live Location...",
                          style: TextStyle(
                            fontSize: 18,
                            color: color,
                          ),
                        ),
                      ),
                    ),
      ),
            )
        : Container(),
            Positioned(
      top: 40,
            left: 20,
            child: InkWell(
              onTap: () {
                _drawerscaffoldkey.currentState!.openDrawer();
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 0.5,
                    )),
                child: Center(
                  child: Icon(
                    Icons.menu,
                    color: color,
                  ),
                ),
              ),
            ),
          ),
      //       Positioned(
      // top: 80,
      // left: 20,
      // child: InkWell(
      //   onTap: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => const booked()));
      //   },
      //   child: Container(
      //     height: 40,
      //     width: 40,
      //     decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(10),
      //         color: Colors.white,
      //         border: Border.all(
      //           color: Colors.black,
      //           width: 0.5,
      //         )),
      //     child: const Center(
      //       child: Icon(Icons.bookmark),
      //     ),
      //   ),
      // ),
      //       ),
            // Positioned(
            //   top: 45,
            //   right: 20,
            //   child: Container(
            //     height: 35,
            //     width: 175,
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(17),
            //         color: Colors.white),
            //     child: Row(
            //       children: [
            //         SizedBox(
            //           width: 8,
            //         ),
            //         Icon(
            //           Icons.ev_station,
            //           color: Colors.amber,
            //         ),
            //         SizedBox(
            //           width: 3,
            //         ),
            //         Text("Ev Parking"),
            //         SizedBox(
            //           width: 5,
            //         ),
            //         SlidingSwitch(
            //           height: 25,
            //           width: 50,
            //           animationDuration: Duration(milliseconds: 300),
            //           textOff: '',
            //           textOn: '',
            //           value: false,
            //           onChanged: (bool value) {},
            //           onSwipe: () {},
            //           onDoubleTap: () {},
            //           onTap: () {},
            //         )
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
          );
  }
}
