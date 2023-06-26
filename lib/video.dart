import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlay extends StatefulWidget {
  const VideoPlay({Key? key}) : super(key: key);

  @override
  State<VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  late VideoPlayerController a;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeVIdeoPlayer();
    setState(() {});
  }

  Future<void> initializeVIdeoPlayer() async {
    a = VideoPlayerController.network(
        "https://firebasestorage.googleapis.com/v0/b/fir-a-to-z.appspot.com/o/ShortVideos%2Ftanjiro%40kamado.demonslayercorp_vid?alt=media&token=8eb1073b-1d1e-4d33-abbe-042b2fedefd8");
    a.initialize().then((value) => setState(() {}));
    a.setLooping(true);
    a.play();
    a.addListener(() {
      setState(() {});
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyApp"),
      ),
      body: ListView(
        children: [
          Center(
              child: a.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: a.value.aspectRatio,
                      child: GestureDetector(
                        onTap: (){},
                          child: VideoPlayer(a)),
                    )
                  : Placeholder()),
        ],
      ),
    );
  }
}
