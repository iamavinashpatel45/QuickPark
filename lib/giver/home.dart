import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:location/location.dart';
import 'slidinguppanel/slidinguppanel.dart';

class g_home extends StatefulWidget {
  const g_home({Key? key}) : super(key: key);

  @override
  State<g_home> createState() => _g_homeState();
}

class _g_homeState extends State<g_home> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData? livelocation;

  Future go_on_liveloaction()async {
    Location location = Location();
    await location.getLocation().then((location) => {livelocation = location});
    setState(() {
    });
  }

  Future getlocation() async {
    // await Geolocator.requestPermission();
    Location location = Location();
    await location.getLocation().then((location) => {livelocation = location});
    setState(() {});
  }

  @override
  void initState() {
    getlocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: livelocation == null
          ? Center(
              child: Image.asset("assets/logo_.jpg"),
            )
          : Stack(
              children: [
                Container(
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(
                            livelocation!.latitude!, livelocation!.longitude!),
                        zoom: 15),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: {
                      Marker(
                          markerId: MarkerId('Live Loaction'),
                          position: LatLng(livelocation!.latitude!,
                              livelocation!.longitude!))
                    },
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Center(
                      child: Icon(Icons.menu),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 120,
                  left: 10,
                  child: InkWell(
                    onTap: (){
                      getlocation();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: Center(
                        child: Icon(Icons.my_location),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 45,
                  right: 20,
                  child: Container(
                    height: 35,
                    width: 175,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: Colors.white),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          Icons.ev_station,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text("Ev Parking"),
                        SizedBox(
                          width: 5,
                        ),
                        SlidingSwitch(
                          height: 25,
                          width: 50,
                          animationDuration: Duration(milliseconds: 300),
                          textOff: '',
                          textOn: '',
                          value: false,
                          onChanged: (bool value) {},
                          onSwipe: () {},
                          onDoubleTap: () {},
                          onTap: () {},
                        )
                      ],
                    ),
                  ),
                ),
                slindingup(),
              ],
            ),
    );
  }
}
