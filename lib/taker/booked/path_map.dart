// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:parking/account/account.dart';
//
// class path_map extends StatefulWidget {
//   final String uid;
//
//   const path_map({Key? key, required this.uid}) : super(key: key);
//
//   @override
//   State<path_map> createState() => _path_mapState();
// }
//
// class _path_mapState extends State<path_map> {
//   bool pro = true;
//   GoogleMapController? _controller;
//   Location location = Location();
//   Map<String, dynamic>? data;
//   LatLng currontlocation =
//       LatLng(account.livelocation!.latitude!, account.livelocation!.longitude!);
//   LatLng? destination;
//   List<LatLng> polylineCoordinates = [];
//   Marker? sourceposition, destinationposition;
//
//   get_data() async {
//     await FirebaseFirestore.instance
//         .collection("user_data")
//         .get()
//         .then((value) => {
//               for (int i = 0; i < value.docs.length; i++)
//                 {
//                   if (value.docs[i].id == widget.uid)
//                     {
//                       data = value.docs[i].data(),
//                     }
//                 },
//             });
//     setmarker();
//   }
//
//   setmarker() {
//     destination = LatLng(22.5969758, 72.8253755);
//     sourceposition = Marker(
//       markerId: MarkerId("source"),
//       position: currontlocation,
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
//     );
//     destinationposition = Marker(
//       markerId: MarkerId("source"),
//       position: destination!,
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
//     );
//     getnavigator();
//   }
//
//   getnavigator() async {
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       "AIzaSyDTxkR2nw7wDnMZKwFvFPAw8ePxg2YZ0-c", // Google Maps API Key
//       PointLatLng(currontlocation.latitude, currontlocation.longitude),
//       PointLatLng(destination!.latitude, destination!.longitude),
//       travelMode: TravelMode.driving,
//     );
//     print("147852369");
//     print(result.errorMessage);
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         print("147852369");
//         print(point);
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     }
//     print("147852369");
//     print(polylineCoordinates);
//     setState(() {
//       pro = false;
//     });
//   }
//
//   // getnavigation() async {
//   //   LocationData _location;
//   //   _location = await location.getLocation();
//   //   currontlocation = LatLng(_location.latitude!, _location.longitude!);
//   //   location.onLocationChanged.listen((event) {
//   //     currontlocation = LatLng(event.latitude!, event.longitude!);
//   //     _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//   //       target: currontlocation,
//   //       zoom: 16,
//   //     )));
//   //     _controller!
//   //         .showMarkerInfoWindow(MarkerId(sourceposition!.markerId.value));
//   //     sourceposition = Marker(
//   //         markerId: MarkerId("source"),
//   //         position: currontlocation,
//   //         icon:
//   //             BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
//   //         infoWindow: InfoWindow(
//   //             title: double.parse(getdistance(
//   //                         currontlocation.latitude,
//   //                         currontlocation.longitude,
//   //                         destination!.latitude,
//   //                         destination!.longitude)
//   //                     .toString())
//   //                 .toString()));
//   //     getdiareation(currontlocation);
//   //   });
//   //   setState(() {
//   //     pro = false;
//   //   });
//   // }
//   //
//   // double getdistance(lat1, lon1, lat2, lon2) {
//   //   var p = 0.017453292519943295;
//   //   var c = cos;
//   //   var a = 0.5 -
//   //       c((lat2 - lat1) * p) / 2 +
//   //       c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
//   //   return 12742 * asin(sqrt(a));
//   // }
//   //
//   // getdiareation(LatLng latLng) async {
//   //   List<LatLng> polylineCoordinates = [];
//   //   List points = [];
//   //   polylinePoints = PolylinePoints();
//   //   PolylineResult result = await polylinePoints!.getRouteBetweenCoordinates(
//   //     "AIzaSyAB5KbtC1YpO6U9mZDZEE0_wJ6QAZ8EQNY", // Google Maps API Key
//   //     PointLatLng(currontlocation.latitude, currontlocation.longitude),
//   //     PointLatLng(destination!.latitude, destination!.longitude),
//   //     travelMode: TravelMode.driving,
//   //   );
//   //   if (result.points.isNotEmpty) {
//   //     result.points.forEach((PointLatLng point) {
//   //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//   //     });
//   //     addpolyline(polylineCoordinates);
//   //   }
//   // }
//
//   // addpolyline(List<LatLng> list) {
//   //   PolylineId id = PolylineId('poly');
//   //   Polyline polyline = Polyline(
//   //     polylineId: id,
//   //     color: Colors.red,
//   //     points: list,
//   //     width: 3,
//   //   );
//   //   polylines[id] = polyline;
//   //   setState(() {});
//   // }
//
//   @override
//   void initState() {
//     get_data();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: pro
//           ? Center(child: CircularProgressIndicator())
//           : Container(
//               child: GoogleMap(
//                 mapType: MapType.normal,
//                 zoomControlsEnabled: false,
//                 polylines: {
//                   Polyline(
//                     polylineId: const PolylineId('route'),
//                     points: polylineCoordinates,
//                   )
//                 },
//                 initialCameraPosition: CameraPosition(
//                     target: LatLng(account.livelocation!.latitude!,
//                         account.livelocation!.longitude!),
//                     zoom: 16),
//                 onMapCreated: (GoogleMapController controller) {
//                   _controller = controller;
//                 },
//                 markers: {sourceposition!, destinationposition!},
//               ),
//             ),
//     );
//   }
// }
