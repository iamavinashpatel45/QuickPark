import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/account/account.dart';
import 'package:upi_india/upi_app.dart';
import 'package:upi_india/upi_response.dart';

class booking_details {
  static LatLng? next;
  static String? address;
  static num vehicle_type = 1;
  static DateTime? a_time;
  static DateTime? a_date;
  static DateTime? l_time;
  static DateTime? l_date;
  static Duration? difference;
  static double? amount;
  static UpiResponse? transactiondetails;
  static List<UpiApp>? apps;
  static Marker? marker;

  static Future<bool> add_data(BuildContext context) async {
    if (await fun.checkInternet()) {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String? vehical, vehical_path;
      if (vehicle_type == 1) {
        vehical = "Car";
        vehical_path = 'assets/vehicles/car.png';
      } else if (vehicle_type == 2) {
        vehical = "Bike";
        vehical_path = 'assets/vehicles/bike.png';
      } else if (vehicle_type == 3) {
        vehical = "Van";
        vehical_path = 'assets/vehicles/van.png';
      } else if (vehicle_type == 4) {
        vehical = "Bus";
        vehical_path = 'assets/vehicles/bus.png';
      } else if (vehicle_type == 5) {
        vehical = "6m Truck";
        vehical_path = 'assets/vehicles/s_truck.png';
      } else if (vehicle_type == 6) {
        vehical = "8m Truck";
        vehical_path = 'assets/vehicles/b_truck.png';
      }
      String a_time = a_date!.day.toString() +
          '/' +
          a_date!.month.toString() +
          ' - ' +
          TimeOfDay(
                  hour: booking_details.a_time!.hour,
                  minute: booking_details.a_time!.minute)
              .format(context);
      String l_time = l_date!.day.toString() +
          '/' +
          l_date!.month.toString() +
          ' - ' +
          TimeOfDay(
                  hour: booking_details.l_time!.hour,
                  minute: booking_details.l_time!.minute)
              .format(context);
      String g_id = marker!.markerId.value.toString();
      String? g_num;
      double a=1234;
      String? random=vehical!+"Quick_Park"+a.toString();
      a=a+5;
      DatabaseReference db = FirebaseDatabase.instance.ref();
      db = FirebaseDatabase.instance.ref("booking(user)/" + uid);
      await FirebaseFirestore.instance
          .collection("user_data")
          .doc(g_id)
          .get()
          .then((value) => {g_num = value.data()!.values.toList()[3]});
      Map<String, String> data = {
        "t_id": uid,
        "g_id": g_id,
        "address": booking_details.address!,
        "num": g_num!,
        "atime": a_time,
        "ltime": l_time,
        "random": random,
        "ldate": booking_details.l_time.toString(),
        "amount": booking_details.amount.toString(),
        "type": vehical,
        "vehical_path": vehical_path!
      };
      bool result = false;
      await db
          .push()
          .set(data)
          .then((value) => {result = true})
          .onError((error, stackTrace) => {result = false});
      data = {
        "fname": account.fname_!,
        "lname": account.lname_!,
        "t_id": uid,
        "g_id": g_id,
        "address": booking_details.address!,
        "num": account.num_!,
        "atime": a_time,
        "ltime": l_time,
        "random": random,
        "ldate": booking_details.l_time.toString(),
        "type": vehical,
        "amount": booking_details.amount.toString(),
        "type": vehical,
        "vehical_path": vehical_path
      };
      db = FirebaseDatabase.instance
          .ref("booking/" + marker!.markerId.value.toString());
      await db
          .push()
          .set(data)
          .then((value) => {result = true})
          .onError((error, stackTrace) => {result = false});

      return result;
    } else {
      Fluttertoast.showToast(msg: "You Your Internet connection");
      return false;
    }
  }
}

