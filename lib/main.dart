import 'package:flutter/material.ani.dart' if (dart.library.html) 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const Calendar3DApp());
}

class Calendar3DApp extends StatelessWidget {
  const Calendar3DApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3D Calendar',
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

class _CalendarHomeScreenState extends State<CalendarHomeScreen> with SingleTickerProviderStateMixin {
  DateTime _focusedDate = DateTime.now();
  DateTime? _selectedDate;
  Map<String, String> _events = {};
  late AnimationController _controller;
  double _dragValue = 0.0;

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDate;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _loadEvents();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final String? eventsString = prefs.getString('calendar_events');
    if (eventsString != null) {
      setState(() {
        _events = Map<String, String>.from(json.decode(eventsString));
      });
    }
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('calendar_events', json.encode(_events));
  }

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _showEventDialog(DateTime date) {
    final key = _dateKey(date);
    final controller = TextEditingController(text: _events[key] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Event on ${DateFormat('MMM dd, yyyy').format(date)}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter event notes here...',
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: const Color(0xFF0F172A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              setState(() {
                if (controller.text.trim().isEmpty) {
                  _events.remove(key);
                } else {
                  _events[key] = controller.text.trim();
                }
              });
              _saveEvents();
              Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(_focusedDate.year, _focusedDate.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
    final int startingWeekday = firstDayOfMonth.weekday % 7;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_month_rounded, color: Color(0xFF818CF8), size: 28),
            const SizedBox(width: 10),
            Text(
              DateFormat('MMMM yyyy').format(_focusedDate),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.today, color: Color(0xFF818CF8)),
            onPressed: () {
              setState(() {
                _focusedDate = DateTime.now();
                _selectedDate = _focusedDate;
              });
            },
          ),
        ],
      },
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          _dragValue += details.delta.dx;
        },
        onHorizontalDragEnd: (details) {
          if (_dragValue > 50) {
            setState(() {
              _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1, 1);
            });
          } else if (_dragValue < -50) {
            setState(() {
              _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1, 1);
            });
          }
          _dragValue = 0.0;
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Weekday headers
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                      .map((day) => SizedBox(
                            width: 40,
                            child: Text(
                              day,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 10),
              // 3D Calendar Grid Card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(0.05),
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B).withOpacity(0.85),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                            const BoxShadow(
                              color: Color(0xFF6366F1),
                              blurRadius: 1,
                              spreadRadius: 0,
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1.5,
                          ),
                        ),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 42,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                          itemBuilder: (context, index) {
                            final dayIndex = index - startingWeekday + 1;
                            if (dayIndex <= 0 || dayIndex > daysInMonth) {
                              return const SizedBox.shrink();
                            }
                            final currentDate = DateTime(_focusedDate.year, _focusedDate.month, dayIndex);
                            final isToday = currentDate.year == DateTime.now().year &&
                                currentDate.month == DateTime.now().month &&
                                currentDate.day == DateTime.now().day;
                            final isSelected = _selectedDate != null &&
                                currentDate.year == _selectedDate!.year &&
                                currentDate.month == _selectedDate!.month &&
                                currentDate.day == _selectedDate!.day;
                            final hasEvent = _events.containsKey(_dateKey(currentDate));

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDate = currentDate;
                                });
                              },
                              onDoubleTap: () {
                                _showEventDialog(currentDate);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF6366F1)
                                      : isToday
                                          ? const Color(0xFF4F46E5).withOpacity(0.4)
                                          : const Color(0xFF0F172A),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF6366F1).withOpacity(0.6),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          )
                                        ]
                                      : [],
                                  border: Border.all(
                                    color: isToday ? const Color(0xFF818CF8) : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Text(
                                        '$dayIndex',
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : Colors.white70,
                                          fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    if (hasEvent)
                                      Positioned(
                                        bottom: 4,
                                        right: 0,
                                        left: 0,
                                        child: Center(
                                          child: Container(
                                            width: 5,
                                            height: 5,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF34D399),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Selected Date Details & Event Banner
              if (_selectedDate != null) ...[
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event_note_rounded, color: Color(0xFF34D399), size: 30),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('EEEE, MMM dd, yyyy').format(_selectedDate!),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _events[_dateKey(_selectedDate!)] ?? 'Double tap date above to add event note',
                              style: TextStyle(
                                color: _events.containsKey(_dateKey(_selectedDate!)) ? Colors.white70 : Colors.white38,
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF818CF8)),
                        onPressed: () => _showEventDialog(_selectedDate!),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
