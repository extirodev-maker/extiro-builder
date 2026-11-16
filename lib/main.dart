import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(const FuturisticTodoApp());
}

class FuturisticTodoApp extends StatelessWidget {
  const FuturisticTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexus Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          secondary: Color(0xFF7C4DFF),
          surface: Color(0xFF1D1E33),
        ),
      ),
      home: const TodoHomeScreen(),
    );
  }
}

class Task {
  String title;
  String category;
  bool isCompleted;
  Task({required this.title, required this.category, this.isCompleted = false});
}

class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  final List<Task> _tasks = [
    Task(title: 'Quantum Core Update', category: 'Dev', isCompleted: true),
    Task(title: 'Neural Network Sync', category: 'AI'),
    Task(title: 'Cyber Security Patch', category: 'Work'),
  ];

  final TextEditingController _controller = TextEditingController();
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Dev', 'AI', 'Work', 'Personal'];

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _tasks.add(Task(
          title: _controller.text,
          category: _selectedCategory == 'All' ? 'Personal' : _selectedCategory,
        ));
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _selectedCategory == 'All'
        ? _tasks
        : _tasks.where((t) => t.category == _selectedCategory).toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E21),
              Color(0xFF1D1E33),
              Color(0xFF0F2027),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'NEXUS TASK',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Color(0xFF00E5FF),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'System Operational',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D1E33),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.fingerprint, color: Color(0xFF00E5FF), size: 28),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // Input Field
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1E33).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF7C4DFF).withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Enter new protocol...',
                            hintStyle: TextStyle(color: Colors.white38),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bolt, color: Color(0xFF00E5FF)),
                        onPressed: _addTask,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Categories
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          },
                          selectedColor: const Color(0xFF00E5FF),
                          backgroundColor: const Color(0xFF1D1E33),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.black : Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'ACTIVE PROTOCOLS',
                  style: TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 1.5),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: filteredTasks.isEmpty
                      ? const Center(
                          child: Text('No protocols found', style: TextStyle(color: Colors.white38)),
                        )
                      : ListView.builder(
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1D1E33).withOpacity(0.4),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: task.isCompleted
                                      ? Colors.greenAccent.withOpacity(0.3)
                                      : const Color(0xFF00E5FF).withOpacity(0.2),
                                ),
                              ),
                              child: ListTile(
                                leading: Checkbox(
                                  value: task.isCompleted,
                                  activeColor: const Color(0xFF00E5FF),
                                  checkColor: Colors.black,
                                  onChanged: (val) {
                                    setState(() {
                                      task.isCompleted = val ?? false;
                                    });
                                  },
                                ),
                                title: Text(
                                  task.title,
                                  style: TextStyle(
                                    color: task.isCompleted ? Colors.white38 : Colors.white,
                                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                                subtitle: Text(
                                  task.category,
                                  style: const TextStyle(color: Color(0xFF7C4DFF), fontSize: 12),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      _tasks.remove(task);
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
      ),
    );
  }
}
