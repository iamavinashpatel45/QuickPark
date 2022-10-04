import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:parking/taker/booking_details.dart';
import 'package:parking/taker/pay/pay.dart';

class datetime_picker_leave extends StatefulWidget {
  const datetime_picker_leave({Key? key}) : super(key: key);

  @override
  State<datetime_picker_leave> createState() => _datetime_picker_leaveState();
}

class _datetime_picker_leaveState extends State<datetime_picker_leave> {
  final _key = GlobalKey<FormState>();
  DateTime datetime=DateTime.now();
  Color color = HexColor("#4f79c6");

  @override
  Widget build(BuildContext context) {
    String a_time = TimeOfDay(
            hour: booking_details.a_time!.hour,
            minute: booking_details.a_time!.minute)
        .format(context);
    return Scaffold(
      backgroundColor: color,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  "assets/clock.png",
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Text(
                booking_details.address!,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 380,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "When Do You want to leave?",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Starting " +
                  booking_details.a_date!.day.toString() +
                  "-" +
                  booking_details.a_date!.month.toString() +
                  "-" +
                  booking_details.a_date!.year.toString() +
                  " at " +
                  a_time,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            DateTimePicker(
                key: _key,
                type: DateTimePickerType.Both,
                startDate: booking_details.a_date,
                endDate: datetime.add(const Duration(days: 7)),
                startTime: booking_details.a_date!.day == DateTime
                    .now()
                    .day
                    ? booking_details.a_time!.add(const Duration(minutes: 30))
                    : DateTime.parse("1969-07-20 00:00:00Z"),
                timeInterval: const Duration(minutes: 30),
            onTimeChanged: (time) {
              setState(() {
                booking_details.l_time = time;
                booking_details.difference = booking_details.l_time!
                    .difference(booking_details.a_time!);
                int dur_hou = booking_details.difference!.inHours;
                double dur_min = (booking_details.difference!.inMinutes -
                    (booking_details.difference!.inHours * 60))/30;
                if (booking_details.vehicle_type == 1) {
                  booking_details.amount = dur_hou * 40 + dur_min * 20;
                  } else if (booking_details.vehicle_type == 2) {
                    booking_details.amount = dur_hou * 30 + dur_min * 15;
                  } else if (booking_details.vehicle_type == 3) {
                    booking_details.amount = dur_hou * 50 + dur_min * 25;
                  } else if (booking_details.vehicle_type == 4) {
                    booking_details.amount = dur_hou * 50 + dur_min * 30;
                  } else if (booking_details.vehicle_type == 5) {
                    booking_details.amount = dur_hou * 80 + dur_min * 40;
                  } else {
                    booking_details.amount = dur_hou * 100 + dur_min * 50;
                  }
                if(booking_details.amount!<0)
                  {
                    booking_details.amount=-(booking_details.amount!);
                  }
                });
              },
              onDateChanged: (date) {
                booking_details.l_date = date;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Back",
                      style: TextStyle(
                        fontSize: 20,
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
                            child: const payment(),
                            type: PageTransitionType.size,
                            duration: const Duration(milliseconds: 500),
                          ));
                    },
                    child: Container(
                      height: 45,
                      width: 120,
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          )),
                      child: const Center(
                        child: Text(
                          'Pay',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
