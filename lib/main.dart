import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const HtmlPreviewApp());
}

class HtmlPreviewApp extends StatelessWidget {
  const HtmlPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTML Live Preview',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const EditorPreviewScreen(),
    );
  }
}

class EditorPreviewScreen extends StatefulWidget {
  const EditorPreviewScreen({super.key});

  @override
  State<EditorPreviewScreen> createState() => _EditorPreviewScreenState();
}

class _EditorPreviewScreenState extends State<EditorPreviewScreen> {
  int _currentIndex = 0;
  final TextEditingController _codeController = TextEditingController();
  late WebViewController _webViewController;

  final String defaultTemplate = '''<!DOCTYPE html>
<html>
<head>
  <style>
    body {
      font-family: Arial, sans-serif;
      background: linear-gradient(135deg, #74b9ff, #a29bfe);
      color: #2d3436;
      text-align: center;
      padding: 50px;
    }
    h1 {
      color: #fff;
      text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
    }
    .card {
      background: white;
      padding: 20px;
      border-radius: 12px;
      box-shadow: 0 4px 15px rgba(0,0,0,0.2);
      display: inline-block;
    }
  </style>
</head>
<body>
  <div class="card">
    <h1>Hello HTML Live!</h1>
    <p>Ye aapka advanced HTML preview app hai.</p>
    <button onclick="alert('Button clicked successfully!')">Click Me</button>
  </div>
</body>
</html>''';

  @override
  void initState() {
    super.initState();
    _loadSavedCode();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000));
  }

  Future<void> _loadSavedCode() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('saved_html_code');
    setState(() {
      _codeController.text = saved ?? defaultTemplate;
    });
    _updatePreview();
  }

  Future<void> _saveCode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_html_code', _codeController.text);
  }

  void _updatePreview() {
    _saveCode();
    _webViewController.loadHtmlString(_codeController.text);
  }

  void _loadTemplate(String code) {
    setState(() {
      _codeController.text = code;
    });
    _updatePreview();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Template loaded successfully!'), duration: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // Page 1: Code Editor with Action Toolbar
      Column(
        children: [
          Container(
            color: const Color(0xFF1E1E1E),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ActionChip(
                    label: const Text('Clear'),
                    avatar: const Icon(Icons.clear, size: 16),
                    onPressed: () {
                      setState(() {
                        _codeController.clear();
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ActionChip(
                    label: const Text('Reset Template'),
                    avatar: const Icon(Icons.refresh, size: 16),
                    onPressed: () => _loadTemplate(defaultTemplate),
                  ),
                  const SizedBox(width: 8),
                  ActionChip(
                    label: const Text('CSS Card'),
                    avatar: const Icon(Icons.code, size: 16),
                    onPressed: () => _loadTemplate('''<!DOCTYPE html>
<html>
<head>
<style>
  body { background: #111; color: #00ffcc; font-family: monospace; padding: 20px; }
  h2 { border-bottom: 2px solid #00ffcc; padding-bottom: 5px; }
</style>
</head>
<body>
  <h2>Cyberpunk Style</h2>
  <p>Live preview is super fast and smooth.</p>
</body>
</html>'''),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFF121212),
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _codeController,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  color: Colors.greenAccent,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your HTML / CSS / JS code here...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),

      // Page 2: Live Preview WebView
      Column(
        children: [
          Container(
            color: Colors.grey[900],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Live Output Preview', style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.blueAccent),
                  onPressed: _updatePreview,
                  tooltip: 'Refresh Preview',
                ),
              ],
            ),
          ),
          Expanded(
            child: WebViewWidget(controller: _webViewController),
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('HTML Live Preview Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow, color: Colors.greenAccent, size: 30),
            tooltip: 'Run & Preview',
            onPressed: () {
              _updatePreview();
              setState(() {
                _currentIndex = 1;
              });
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            _updatePreview();
          }
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: 'HTML Code',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye),
            label: 'Run Preview',
          ),
        ],
      ),
    );
  }
}
