import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';

class MediaViewerService {
  static void showImageViewer(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text('Image Viewer'),
            actions: [
              IconButton(
                icon: Icon(Icons.download),
                onPressed: () => _downloadFile(context, imageUrl),
              ),
            ],
          ),
          body: PhotoView(
            imageProvider: NetworkImage(imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            backgroundDecoration: BoxDecoration(color: Colors.black),
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(
                value: event?.expectedTotalBytes != null
                    ? event!.cumulativeBytesLoaded / event!.expectedTotalBytes!
                    : null,
                color: Colors.amber,
              ),
            ),
            errorBuilder: (context, error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 60),
                  SizedBox(height: 16),
                  Text(
                    'Failed to load image',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap to retry',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void showVideoPlayer(BuildContext context, String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoUrl: videoUrl),
      ),
    );
  }

  static void showAudioPlayer(BuildContext context, String audioUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AudioPlayerScreen(audioUrl: audioUrl),
      ),
    );
  }

  static Future<void> openDocument(BuildContext context, String documentUrl, String fileName) async {
    try {
      // Try to open with external app first
      if (await canLaunchUrl(Uri.parse(documentUrl))) {
        await launchUrl(Uri.parse(documentUrl), mode: LaunchMode.externalApplication);
      } else {
        // Try to open with open_filex for local files
        await OpenFilex.open(documentUrl);
      }
    } catch (e) {
      // Show download option if opening fails
      _showDownloadDialog(context, documentUrl, fileName);
    }
  }

  static void _showDownloadDialog(BuildContext context, String url, String fileName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Open Document'),
        content: Text('Unable to open $fileName. Would you like to download it?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _downloadFile(context, url);
            },
            child: Text('Download'),
          ),
        ],
      ),
    );
  }

  static void _downloadFile(BuildContext context, String url) {
    // Implement file download functionality
    // You can use dio or http package to download files
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Download started...'),
        backgroundColor: Colors.green,
      ),
    );
    print('Downloading file from $url');
  }
}

// Video Player Screen
class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
      await _videoPlayerController.initialize();
      
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.amber,
          handleColor: Colors.amber,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.grey[300]!,
        ),
        placeholder: Container(
          color: Colors.black,
          child: Center(
            child: CircularProgressIndicator(color: Colors.amber),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red, size: 60),
                SizedBox(height: 16),
                Text(
                  'Failed to load video',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );
      
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing video player: $e');
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Video Player'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => MediaViewerService._downloadFile(context, widget.videoUrl),
          ),
        ],
      ),
      body: Center(
        child: _hasError
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 80),
                  SizedBox(height: 16),
                  Text(
                    'Failed to load video',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                      });
                      _initializeVideoPlayer();
                    },
                    child: Text('Retry'),
                  ),
                ],
              )
            : _isInitialized
                ? Chewie(controller: _chewieController!)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.amber),
                      SizedBox(height: 16),
                      Text(
                        'Loading video...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
      ),
    );
  }
}

// Audio Player Screen
class AudioPlayerScreen extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerScreen({Key? key, required this.audioUrl}) : super(key: key);

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _hasError = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
  }

  Future<void> _initializeAudioPlayer() async {
    try {
      // Set up audio player listeners
      _audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _duration = duration;
        });
      });

      _audioPlayer.onPositionChanged.listen((position) {
        setState(() {
          _position = position;
        });
      });

      _audioPlayer.onPlayerStateChanged.listen((state) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      });

      // Set audio source
      await _audioPlayer.setSourceUrl(widget.audioUrl);
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing audio player: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF34B89B),
        foregroundColor: Colors.white,
        title: Text('Audio Player'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => MediaViewerService._downloadFile(context, widget.audioUrl),
          ),
        ],
      ),
      body: Center(
        child: _hasError
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 80),
                  SizedBox(height: 16),
                  Text(
                    'Failed to load audio',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                      });
                      _initializeAudioPlayer();
                    },
                    child: Text('Retry'),
                  ),
                ],
              )
            : _isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.amber),
                      SizedBox(height: 16),
                      Text('Loading audio...'),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Audio visualizer placeholder
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.amber, width: 2),
                        ),
                        child: Icon(
                          _isPlaying ? Icons.music_note : Icons.music_off,
                          size: 80,
                          color: Colors.amber,
                        ),
                      ),
                      
                      SizedBox(height: 40),
                      
                      // Play/Pause button
                      IconButton(
                        onPressed: () {
                          if (_isPlaying) {
                            _audioPlayer.pause();
                          } else {
                            _audioPlayer.resume();
                          }
                        },
                        icon: Icon(
                          _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          size: 60,
                          color: Colors.amber,
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Progress bar
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Slider(
                              value: _position.inSeconds.toDouble(),
                              max: _duration.inSeconds.toDouble(),
                              onChanged: (value) {
                                _audioPlayer.seek(Duration(seconds: value.toInt()));
                              },
                              activeColor: Colors.amber,
                              inactiveColor: Colors.grey[300],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_formatDuration(_position)),
                                  Text(_formatDuration(_duration)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
