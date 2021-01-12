import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../constants.dart';

class CalendarMain extends StatefulWidget {
  @override
  _CalendarMainState createState() => _CalendarMainState();
}

// 6 minute
class _CalendarMainState extends State<CalendarMain>{

  CalendarController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 1.2,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              initialCalendarFormat: CalendarFormat.month,
              calendarController: _controller,
              calendarStyle: CalendarStyle(
                todayColor: kPrimaryLightColor,
                selectedColor: kPrimaryColor,
                todayStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.black38,
                ),
              ),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(20.0)
                ),
                formatButtonTextStyle: TextStyle(
                  color: Colors.white
                ),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (date, events, _) { 
                
              },
            )
          ],
        ),
      ),
    );
  }
}