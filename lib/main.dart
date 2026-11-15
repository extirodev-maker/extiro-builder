import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const Calendar3DApp());
}

class Calendar3DApp extends StatelessWidget {
  const Calendar3DApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3D Calendar App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        fontFamily: 'sans-serif',
      ),
      home: const CalendarHomeScreen(),
    );
  }
}

class CalendarHomeScreen extends StatefulWidget {
  const CalendarHomeScreen({super.key});

  @override
  State<CalendarHomeScreen> createState() => _CalendarHomeScreenState();
}

class _CalendarHomeScreenState extends State<CalendarHomeScreen> {
  DateTime _focusedDate = DateTime.now();
  DateTime? _selectedDate;
  final Map<String, List<String>> _events = {};
  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDate;
  }

  String _dateKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  void _prevMonth() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1, 1);
    });
  }

  void _addEvent(DateTime date) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Add Event for ${DateFormat('MMM dd, yyyy').format(date)}',
            style: const TextStyle(color: Colors.white, fontSize: 18)),
        content: TextField(
          controller: _eventController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter event description',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent, width: 2)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, foregroundColor: Colors.black),
            onPressed: () {
              if (_eventController.text.isNotEmpty) {
                final key = _dateKey(date);
                setState(() {
                  _events.putIfAbsent(key, () => []).add(_eventController.text);
                  _eventController.clear();
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final year = _focusedDate.year;
    final month = _focusedDate.month;
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startingWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    final monthName = DateFormat('MMMM yyyy').format(_focusedDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.layers, color: Colors.cyanAccent),
            SizedBox(width: 10),
            Text('3D Depth Calendar', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.today, color: Colors.cyanAccent),
            onPressed: () => setState(() {
              _focusedDate = DateTime.now();
              _selectedDate = _focusedDate;
            }),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E1B4B), Color(0xFF0F172A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Month Navigation Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.cyanAccent),
                    onPressed: _prevMonth,
                  ),
                  Text(
                    monthName,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.1),
                  ).animate().scale(duration: 300.ms),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.cyanAccent),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
            ),

            // Weekday Headers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                    .map((day) => Expanded(
                          child: Center(
                            child: Text(
                              day,
                              style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 10),

            // 3D Calendar Grid
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: startingWeekday + daysInMonth,
                  itemBuilder: (context, index) {
                    if (index < startingWeekday) {
                      return const SizedBox.shrink();
                    }
                    final dayNumber = index - startingWeekday + 1;
                    final currentDate = DateTime(year, month, dayNumber);
                    final isToday = DateFormat('yyyy-MM-dd').format(currentDate) == DateFormat('yyyy-MM-dd').format(DateTime.now());
                    final isSelected = _selectedDate != null && DateFormat('yyyy-MM-dd').format(currentDate) == DateFormat('yyyy-MM-dd').format(_selectedDate!);
                    final hasEvent = _events.containsKey(_dateKey(currentDate)) && (_events[_dateKey(currentDate)]?.isNotEmpty ?? false);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = currentDate;
                        });
                      },
                      onDoubleTap: () => _addEvent(currentDate),
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.002) // Perspective
                          ..rotateX(isSelected ? -0.1 : 0.0)
                          ..rotateY(isSelected ? 0.1 : 0.0),
                        alignment: Alignment.center,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isSelected
                                  ? [Colors.cyan.shade400, Colors.blue.shade700]
                                  : isToday
                                      ? [Colors.purple.shade400, Colors.deepPurple.shade700]
                                      : [const Color(0xFF1E293B), const Color(0xFF0F172A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected ? Colors.cyanAccent.withOpacity(0.5) : Colors.black.withOpacity(0.4),
                                blurRadius: isSelected ? 12 : 6,
                                offset: isSelected ? const Offset(0, 8) : const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: isToday ? Colors.cyanAccent : Colors.white10,
                              width: isToday ? 2 : 1,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  '$dayNumber',
                                  style: TextStyle(
                                    color: isSelected || isToday ? Colors.white : Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              if (hasEvent)
                                Positioned(
                                  bottom: 6,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: Colors.cyanAccent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 200.ms);
                  },
                ),
              ),
            ),

            // Selected Date & Events Panel
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withOpacity(0.8),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    )
                  ],
                  border: const Border(top: BorderSide(color: Colors.white12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate != null
                              ? DateFormat('EEEE, MMM dd, yyyy').format(_selectedDate!)
                              : 'Select a date',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.cyanAccent),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyanAccent,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            if (_selectedDate != null) {
                              _addEvent(_selectedDate!);
                            }
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Event'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: _selectedDate == null ||
                              !_events.containsKey(_dateKey(_selectedDate!)) ||
                              (_events[_dateKey(_selectedDate!)]?.isEmpty ?? true)
                          ? const Center(
                              child: Text(
                                'No events for this day. Double tap date tile or click Add Event.',
                                style: TextStyle(color: Colors.white54, fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              itemCount: _events[_dateKey(_selectedDate!)]?.length ?? 0,
                              itemBuilder: (context, index) {
                                final eventText = _events[_dateKey(_selectedDate!)]![index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F172A),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.event_note, color: Colors.cyanAccent, size: 20),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          eventText,
                                          style: const TextStyle(color: Colors.white, fontSize: 14),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                                        onPressed: () {
                                          setState(() {
                                            _events[_dateKey(_selectedDate!)]!.removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ).animate().slideX(duration: 200.ms);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
