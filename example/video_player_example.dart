import 'package:flutter/material.dart';
import 'package:route_aware_widget/route_aware_widget.dart';

/// Example: Auto-pause video when navigating away
///
/// This demonstrates a real-world use case where you want to pause
/// a video player when the user navigates to another screen.
void main() {
  runApp(const VideoPlayerApp());
}

class VideoPlayerApp extends StatelessWidget {
  const VideoPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routeObserver = RouteObserver<ModalRoute<dynamic>>();

    return RouteObserverProvider(
      routeObserver: routeObserver,
      child: MaterialApp(
        title: 'Video Player Example',
        navigatorObservers: [routeObserver],
        home: const VideoPlayerPage(),
      ),
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  bool _isPlaying = false;

  void _play() {
    setState(() => _isPlaying = true);
    print('Video playing');
  }

  void _pause() {
    setState(() => _isPlaying = false);
    print('Video paused');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Player')),
      body: RouteAwareWidget(
        onPageAppear: () {
          print('Video page appeared');
          // Auto-resume video if it was playing before
        },
        onPageDisappear: () {
          print('Video page disappeared');
          // Auto-pause video when navigating away
          if (_isPlaying) {
            _pause();
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 200,
                color: Colors.black,
                child: Center(
                  child: Icon(
                    _isPlaying ? Icons.play_arrow : Icons.pause,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isPlaying ? _pause : _play,
                child: Text(_isPlaying ? 'Pause' : 'Play'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
                child: const Text('Go to Settings'),
              ),
              const SizedBox(height: 10),
              const Text(
                'Video will auto-pause when you navigate away',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Settings Page'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Video'),
            ),
          ],
        ),
      ),
    );
  }
}
