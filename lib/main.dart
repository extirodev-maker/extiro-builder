import 'package:flutter/material.dart';

void main() {
  runApp(const RealtimeChatApp());
}

class RealtimeChatApp extends StatelessWidget {
  const RealtimeChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Realtime Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChatRoomsScreen(),
    );
  }
}

class ChatMessage {
  final String sender;
  final String text;
  final String time;
  final bool isMe;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.time,
    required this.isMe,
  });
}

class ChatRoomsScreen extends StatelessWidget {
  const ChatRoomsScreen({super.key});

  final List<Map<String, String>> rooms = const [
    {'name': 'General Discussion', 'lastMsg': 'Welcome to realtime chat!', 'time': '10:42 AM', 'members': '1,240 online'},
    {'name': 'Flutter Developers', 'lastMsg': 'Widgets are awesome!', 'time': '09:15 AM', 'members': '542 online'},
    {'name': 'AI & Tech Talk', 'lastMsg': 'GPT-4o is super fast.', 'time': 'Yesterday', 'members': '890 online'},
    {'name': 'Random Banter', 'lastMsg': 'Coffee is love ❤️', 'time': 'Yesterday', 'members': '320 online'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realtime Rooms', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.deepPurple.shade100,
                child: Text(
                  room['name']![0],
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
              ),
              title: Text(room['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(room['lastMsg']!, style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(room['members']!, style: const TextStyle(fontSize: 11, color: Colors.green)),
                    ],
                  ),
                ],
              ),
              trailing: Text(room['time']!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(roomName: room['name']!),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create Room feature coming soon!')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Room'),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String roomName;
  const ChatScreen({super.key, required this.roomName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<ChatMessage> _messages = [
    ChatMessage(sender: 'Aarav', text: 'Hello everyone!', time: '10:30 AM', isMe: false),
    ChatMessage(sender: 'Priya', text: 'Hey Aarav, welcome!', time: '10:32 AM', isMe: false),
    ChatMessage(sender: 'You', text: 'Hi all, glad to be here.', time: '10:35 AM', isMe: true),
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    
    final text = _controller.text.trim();
    _controller.clear();

    setState(() {
      _messages.add(
        ChatMessage(sender: 'You', text: text, time: '10:45 AM', isMe: true),
      );
      _isTyping = true;
    });

    _scrollToBottom();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(
            ChatMessage(
              sender: 'Bot / Peer',
              text: 'Thanks for your message! This is a simulated realtime reply in ${widget.roomName}.',
              time: '10:46 AM',
              isMe: false,
            ),
          );
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(widget.roomName[0], style: const TextStyle(color: Colors.deepPurple)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.roomName, style: const TextStyle(fontSize: 16)),
                const Text('Live Realtime Room', style: TextStyle(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: msg.isMe ? Colors.deepPurple.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!msg.isMe)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              msg.sender,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                            ),
                          ),
                        Text(
                          msg.text,
                          style: const TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg.time,
                          style: const TextStyle(fontSize: 9, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Someone is typing...',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey.shade600),
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type realtime message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
