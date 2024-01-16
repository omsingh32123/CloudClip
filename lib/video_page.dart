import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final String Title;
  final String Desc;
  final String Category;
  final String Address;

  const VideoPlayerPage({
    super.key,
    required this.videoUrl,
    required this.Title,
    required this.Desc,
    required this.Category,
    required this.Address,
  });

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    // Initialize the video player controller with the Firebase Storage video URL

    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      showControls: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sw = MediaQuery.of(context).size.width;
    var sh = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: sh * 0.37,
                width: sw,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Color.fromARGB(255, 0, 0, 0),
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextFormField(
                    text: widget.Title,
                    labelText: "Title",
                    prefixIcon: Icons.title_sharp,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 236, 236, 236),
                          ),
                          child: const Center(child: Icon(Icons.thumb_up),),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 236, 236, 236),
                          ),
                          child: const Center(child: Icon(Icons.thumb_down),),
                        ),
                      ),
                      SizedBox(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 236, 236, 236),
                          ),
                          child: const Center(child: Icon(Icons.share),),
                        ),
                      ),
                    ],
                  ),
                  _buildTextFormField(
                    text: widget.Category,
                    labelText: "Category",
                    prefixIcon: Icons.category_sharp,
                  ),
                  _buildTextFormField(
                    text: widget.Desc,
                    labelText: "Description",
                    prefixIcon: Icons.description,
                  ),
                  _buildTextFormField(
                    text: widget.Address,
                    labelText: "Adress",
                    prefixIcon: Icons.location_city,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String text,
    required String labelText,
    required IconData prefixIcon,
  }) {
    return SizedBox(
      child: Expanded(
        child: Container(
          height: 70,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 236, 236, 236),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(prefixIcon),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: SingleChildScrollView(
                      child: Text(
                        text,
                        style: const TextStyle(fontSize: 16),
                      ),
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
}
