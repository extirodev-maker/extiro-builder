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
      title: '3D Calendar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
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
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  
  final Map<String, List<String>> _events = {
    DateFormat('yyyy-MM-dd').format(DateTime.now()): ['Meeting with Extiro AI team', 'Build amazing Flutter apps'],
  };

  final TextEditingController _eventController = TextEditingController();
  double _dragX = 0;
  double _dragY = 0;

  @override
  Widget build(BuildContext context) {
    final String dateKey = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final dayEvents = _events[dateKey] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('✨ 3D Perspective Calendar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _dragX += details.delta.dx * 0.005;
            _dragY -= details.delta.dy * 0.005;
          });
        },
        onPanEnd: (_) {
          setState(() {
            _dragX = 0;
            _dragY = 0;
          });
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F0F1A), Color(0xFF241433), Color(0xFF16213E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  'Swipe & Drag anywhere for 3D tilt!',
                  style: TextStyle(color: Colors.white75, fontSize: 13, fontStyle: FontStyle.italic),
                ).animate().fadeIn(duration: 600ms),
                const SizedBox(height: 15),
                
                // 3D Transforming Calendar Card
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001) // perspective
                        ..rotateX(_dragY)
                        ..rotateY(_dragX),
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2A2A40), Color(0xFF1F1F30)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurpleAccent.withOpacity(0.4),
                              blurRadius: 25,
                              offset: const Offset(0, 12),
                            ),
                          ],
                          border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
                                    });
                                  },
                                ),
                                Text(
                                  DateFormat('MMMM yyyy').format(_focusedDate),
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
                                    });
                                  },
                                ),
                              ],
                            ),
                            const Divider(color: Colors.white24, height: 20),
                            // Days of week header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                                  .map((d) => Text(d, style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold)))
                                  .toList(),
                            ),
                            const SizedBox(height: 10),
                            // Days Grid
                            Expanded(
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                ),
                                itemCount: 35,
                                itemBuilder: (context, index) {
                                  final firstDayOfMonth = DateTime(_focusedDate.year, _focusedDate.month, 1);
                                  final startingWeekday = firstDayOfMonth.weekday - 1;
                                  final dayNumber = index - startingWeekday + 1;
                                  
                                  final daysInMonth = DateTime(_focusedDate.year, _focusedDate.month + 1, 0).day;
                                  if (dayNumber < 1 || dayNumber > daysInMonth) {
                                    return const SizedBox.shrink();
                                  }

                                  final currentDate = DateTime(_focusedDate.year, _focusedDate.month, dayNumber);
                                  final isSelected = currentDate.year == _selectedDate.year &&
                                      currentDate.month == _selectedDate.month &&
                                      currentDate.day == _selectedDate.day;

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedDate = currentDate;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isSelected ? Colors.deepPurple : Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(10),
                                        border: isSelected ? Border.all(color: Colors.cyanAccent, width: 1.5) : null,
                                      },
                                      alignment: Alignment.center,
                                      child: Text(
                                        '$dayNumber',
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : Colors.white70,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Events Section
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFF151525),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, -5)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('dd MMM yyyy').format(_selectedDate),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.cyanAccent),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle, color: Colors.deepPurpleAccent, size: 28),
                              onPressed: () => _showAddEventDialog(context, dateKey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: dayEvents.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No events for this day. Tap + to add!',
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: dayEvents.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: const Color(0xFF22223B),
                                      margin: const EdgeInsets.symmetric(vertical: 4),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      child: ListTile(
                                        leading: const Icon(Icons.event_note, color: Colors.deepPurpleAccent),
                                        title: Text(dayEvents[index], style: const TextStyle(color: Colors.white)),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                          onPressed: () {
                                            setState(() {
                                              dayEvents.removeAt(index);
                                            });
                                          },
                                        ),
                                      ),
                                    );
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
        ),
      ),
    );
  }

  void _showAddEventDialog(BuildContext context, String dateKey) {
    _eventController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F1F30),
        title: const Text('Add Event', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _eventController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter event title',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.deepPurpleAccent)),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
            child: const Text('Add'),
            onPressed: () {
              if (_eventController.text.isNotEmpty) {
                setState(() {
                  if (_events[dateKey] == null) {
                    _events[dateKey] = [];
                  }
                  _events[dateKey]!.add(_eventController.text);
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
