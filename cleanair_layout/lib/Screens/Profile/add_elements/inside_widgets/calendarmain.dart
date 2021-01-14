import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cleanair_layout/BusinessLogic/database/db.dart';
import '../../../../constants.dart';

class Tuple{
  final String start;
  final String end;
  Tuple (this.start,this.end){}
}

class CalendarMain extends StatefulWidget {
  @override
  _CalendarMainState createState() => _CalendarMainState();
}

// 6 minute
class _CalendarMainState extends State<CalendarMain>{
  var _selectedEvents;
  Map<DateTime, List<dynamic>> _events;
  CalendarController _controller;

  DateTime convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');

    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    print("formatted: ${formatted.runtimeType} ${formatted}");
    return DateTime.parse(formatted);
  }
  String convertTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateFormat serverFormater = DateFormat('HH:mm:ss');

    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    print("formatted: ${formatted.runtimeType} ${formatted}");
    return formatted;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
  }

  Future <List<dynamic>> get_run_dates() async {
    var list_runs = await DB.time_query();
    print("TIME QUERY ${list_runs}");
    return list_runs;
  }

  Map <DateTime,List<dynamic>> _groupEvents(List<dynamic> events) {
    Map <DateTime,List<dynamic>> response= {};
    events.forEach((element) {
      DateTime runDate = convertDateTimeDisplay(element["min(measure_time)"]);
      if (response[runDate] == null) response[runDate] = [];
      response[runDate].add(Tuple(convertTimeDisplay(element["min(measure_time)"]),
          convertTimeDisplay(element["max(measure_time)"])));
    });
    return response;
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
      body: FutureBuilder<List<dynamic>>(
        future: get_run_dates(),
        builder: (context, snapshot){
          if (snapshot.hasData) {
            List<dynamic> dates = snapshot.data;
            if (dates.isNotEmpty)
              _events = _groupEvents(dates);
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TableCalendar(
                  events: _events,
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
                  builders: CalendarBuilders(
                    selectedDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                    todayDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  onDaySelected: (date, events, _) {
                    setState(() {
                      _selectedEvents = events;

                    });
                  },
                ),
                ..._selectedEvents.map((event) => ListTile(
                  title: Text("${event.start} - ${event.end}"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EventDetailsPage(
                              event: event,
                            )));
                  },
                )),
              ],
            ),
          );
        },
      )
    );
  }
}

class EventDetailsPage extends StatelessWidget {
  final Tuple event;
  const EventDetailsPage({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("${event.start} - ${event.end}", style: Theme
                .of(context)
                .textTheme
                .display1,),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}