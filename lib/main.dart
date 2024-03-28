import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MoodTrackerPage(),
    );
  }
}

class MoodTrackerPage extends StatefulWidget {
  @override
  _MoodTrackerPageState createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  late DateTime _selectedDay = DateTime.now();
  late CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _focusedDay = DateTime.now();
  late ValueNotifier<List<Event>> _selectedEvents;
  late Map<DateTime, List<Event>> _events = {};
  String _selectedMood = '😊'; // Default mood

  @override
  void initState() {
    super.initState();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents.value = _getEventsForDay(selectedDay);
      _selectedMood = _getMoodForDay(selectedDay);
    });
  }

  String _getMoodForDay(DateTime day) {
    var events = _getEventsForDay(day);
    if (events.isNotEmpty) {
      return events.first.title;
    }
    return '😊'; // Default mood
  }

  void _setMoodForDay(DateTime day, String mood) {
    setState(() {
      _events.update(
        day,
            (events) => [Event(mood)],
        ifAbsent: () => [Event(mood)],
      );
      _selectedMood = mood;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Tracker'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableGestures: AvailableGestures.all,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: _onDaySelected,
          ),
          SizedBox(height: 20),
          Text(
            'Selected Mood for ${_selectedDay.toString().substring(0, 10)}:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            _selectedMood,
            style: TextStyle(fontSize: 40),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMoodButton('😊'),
              _buildMoodButton('😄'),
              _buildMoodButton('😐'),
              _buildMoodButton('😕'),
              _buildMoodButton('😢'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodButton(String mood) {
    return GestureDetector(
      onTap: () {
        _setMoodForDay(_selectedDay, mood);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _selectedMood == mood ? Colors.blue : Colors.grey[200],
        ),
        child: Text(
          mood,
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}

class Event {
  final String title;

  Event(this.title);
}
