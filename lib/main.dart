import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

void main() {
  runApp(const SongPlayerApp());
}

class SongPlayerApp extends StatelessWidget {
  const SongPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Song Player',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const PlayerHomePage(),
    );
  }
}

class Song {
  final String title;
  final String artist;
  final String albumArt;
  final String url;

  Song({
    required this.title,
    required this.artist,
    required this.albumArt,
    required this.url,
  });
}

class PlayerHomePage extends StatefulWidget {
  const PlayerHomePage({super.key});

  @override
  State<PlayerHomePage> createState() => _PlayerHomePageState();
}

class _PlayerHomePageState extends State<PlayerHomePage> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  int _currentIndex = 0;

  final List<Song> _songs = [
    Song(
      title: 'Acoustic Breeze',
      artist: 'Bensound',
      albumArt: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=500',
      url: 'https://www.bensound.com/bensound-music/bensound-acousticbreeze.mp3',
    ),
    Song(
      title: 'Sunny',
      artist: 'Bensound',
      albumArt: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=500',
      url: 'https://www.bensound.com/bensound-music/bensound-sunny.mp3',
    ),
    Song(
      title: 'Creative Minds',
      artist: 'Bensound',
      albumArt: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=500',
      url: 'https://www.bensound.com/bensound-music/bensound-creativeminds.mp3',
    ),
    Song(
      title: 'Ukulele',
      artist: 'Bensound',
      albumArt: 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=500',
      url: 'https://www.bensound.com/bensound-music/bensound-ukulele.mp3',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration = newDuration;
      });
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });

    _playCurrentSong();
  }

  Future<void> _playCurrentSong() async {
    Source urlSource = UrlSource(_songs[_currentIndex].url);
    await _audioPlayer.play(urlSource);
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  void _nextSong() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _songs.length;
    });
    _playCurrentSong();
  }

  void _prevSong() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _songs.length) % _songs.length;
    });
    _playCurrentSong();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  } 

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final song = _songs[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Music Player'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    song.albumArt,
                    height: 280,
                    width: 280,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    song.artist,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Slider(
                    min: 0,
                    max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1.0,
                    value: _position.inSeconds.toDouble().clamp(0.0, _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1.0),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(position);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatTime(_position)),
                        Text(_formatTime(_duration)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 36,
                        icon: const Icon(LucideIcons.skip_back),
                        onPressed: _prevSong,
                      ),
                      const SizedBox(width: 24),
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: IconButton(
                          iconSize: 36,
                          color: Theme.of(context).colorScheme.onPrimary,
                          icon: Icon(_isPlaying ? LucideIcons.pause : LucideIcons.play),
                          onPressed: _togglePlayPause,
                        ),
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        iconSize: 36,
                        icon: const Icon(LucideIcons.skip_forward),
                        onPressed: _nextSong,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
