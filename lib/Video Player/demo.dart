import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaItem {
  final String type;
  final String url;

  MediaItem({required this.type, required this.url});
}

class VideoApp extends StatelessWidget {
  final List<MediaItem> mediaList = [
    MediaItem(type: 'video', url: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
    MediaItem(type: 'image', url: 'https://c.saavncdn.com/120/Farrey-Hindi-2023-20231120143048-500x500.jpg'),
    // Add more media items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Media List'),
        ),
        body: ListView.builder(
          itemCount: mediaList.length,
          itemBuilder: (context, index) {
            return MediaItemCard(mediaItem: mediaList[index]);
          },
        ),
      ),
    );
  }
}

class MediaItemCard extends StatelessWidget {
  final MediaItem mediaItem;

  MediaItemCard({required this.mediaItem});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
          children: [
            if (mediaItem.type == 'video')
              VideoPlayerScreen(url: mediaItem.url),
            if (mediaItem.type == 'image')
              Container(
                  child: Image.network(mediaItem.url,fit: BoxFit.fill,)),
          ],
        ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {

  final String url;
  const VideoPlayerScreen({super.key, required this.url});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.url,
      ),
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            height: 300,
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(_controller),
            )
        ),
        Center(

          child: FloatingActionButton(
            onPressed: () {
              // Wrap the play or pause in a call to `setState`. This ensures the
              // correct icon is shown.
              setState(() {
                // If the video is playing, pause it.
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  // If the video is paused, play it.
                  _controller.play();
                }
              });
            },
            // Display the correct icon depending on the state of the player.
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ),
      ],
    );
  }
}