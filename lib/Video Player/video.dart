import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class MediaItem {
  final String type;
  final String url;

  MediaItem({required this.type, required this.url});
}

class VideoApp extends StatelessWidget {
  final List<MediaItem> mediaList = [
    MediaItem(type: 'video', url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4'),
    MediaItem(type: 'image', url: 'https://c.saavncdn.com/057/Barse-Re-From-Manush-Hindi-Hindi-2023-20231113122507-500x500.jpg'),
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
            VideoPlayerWidget(url: mediaItem.url),
          if (mediaItem.type == 'image')
            Container(
              height: 350,
                width: double.infinity,
                child: Image.network(mediaItem.url,fit: BoxFit.cover,)),
        ],
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  VideoPlayerWidget({required this.url});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {

  late VideoPlayerController _controller;


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    // Implement video player widget here
    // You may use packages like chewie or video_player for video playback
    // Example: https://pub.dev/packages/chewie
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Container(
                height: 350, // Set the height as needed
                color: Colors.black,
                child:  Center(
                  child: _controller.value.isInitialized
                      ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                      : Container(),
                ),
              ),
            ),
            Center(
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
            ),
          ],

        )


      ],
    );
  }
}
