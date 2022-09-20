import 'package:flutter/material.dart';
import 'package:parking/account/account.dart';

import '../booking_details.dart';

class t_vehicle extends StatefulWidget {
  @override
  State<t_vehicle> createState() => _t_vehicleState();
}

class _t_vehicleState extends State<t_vehicle> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Choose Your Vehicle",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
            itemCount: account.data_vehicle!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: InkWell(
                  onTap: () {
                    booking_details.vehicle_type =
                        account.data_vehicle![index]['id'];
                    Navigator.pop(context);
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
                              width: booking_details.vehicle_type ==
                                      account.data_vehicle![index]['id']
                                  ? 2
                                  : 0)),
                      child: ListTile(
                        leading:
                            Image.asset(account.data_vehicle![index]['image']),
                        title: Text(
                          account.data_vehicle![index]['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                          account.data_vehicle![index]['desc'],
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
