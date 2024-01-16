import 'dart:io';

import 'package:black_coffer/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Videod extends StatefulWidget {
  final String videoPath;
  final String phonenumber;
  final String address;
  final String localpath;
  const Videod(
      {super.key,
      required this.videoPath,
      required this.phonenumber,
      required this.address,
      required this.localpath});

  @override
  State<Videod> createState() => _VideodState();
}

class _VideodState extends State<Videod> {
  TextEditingController VideoTitle = TextEditingController();
  TextEditingController VideoDesc = TextEditingController();
  TextEditingController category = TextEditingController();
  late VideoPlayerController _controller;
  var buttonpressed = false;
  @override
  void initState() {
    super.initState();
    print(widget.localpath);
    _controller = VideoPlayerController.file(File(widget.localpath))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Center(
          child: Text(
            'Description Page',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.27,
                        width: MediaQuery.of(context).size.width,
                      
                        child: _controller.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: Stack(
                                  children: [
                                    VideoPlayer(_controller),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            if (_controller.value.isPlaying) {
                                              _controller.pause();
                                            } else {
                                              _controller.play();
                                            }
                                          });
                                        },
                                        child: Icon(
                                          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildTextFormField(
                  controller: VideoTitle,
                  labelText: "Title",
                  enable: true,
                  prefixIcon: Icons.title_sharp,
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  controller: VideoDesc,
                  enable: true,
                  labelText: "Description of the video",
                  prefixIcon: Icons.description,
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  controller: category,
                  enable: true,
                  labelText: "Category of the video",
                  prefixIcon: Icons.category_sharp,
                ),
                const SizedBox(height: 10),
                _buildTextFormField(
                  controller: TextEditingController()..text = widget.address,
                  enable: false,
                  labelText: "Adress",
                  prefixIcon: Icons.location_city,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 44,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if(!buttonpressed)
                        {
                          setState(() {buttonpressed = true;});
                          try {
                            final FirebaseFirestore firestore =
                                FirebaseFirestore.instance;
                            final DocumentSnapshot clientSnapshot =
                                await firestore
                                    .collection('client')
                                    .doc(widget.phonenumber)
                                    .get();
                            var variable = -1;
                            variable = clientSnapshot['variable'];
                            await firestore
                                .collection('client')
                                .doc(widget.phonenumber)
                                .collection('0')
                                .doc('$variable')
                                .set({
                              'Title': VideoTitle.text,
                              'Desc': VideoDesc.text,
                              'Category': category.text,
                              'Address': widget.address,
                              'path': widget.videoPath,
                            });

                            await firestore
                                .collection('client')
                                .doc(widget.phonenumber)
                                .set({'variable': variable + 1});

                            Fluttertoast.showToast(
                              msg: 'Video Posted',
                              backgroundColor: Colors.grey,
                            );
                            setState(() {buttonpressed = false;});
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Home(valuee: widget.phonenumber),
                              ),
                            );
                          } catch (error) {
                            setState(() {buttonpressed = false;});
                            print('Error: $error');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 0, 0, 0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: Stack(
                      children: [
                        if(!buttonpressed)
                        const Text(
                          "Post",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        if(buttonpressed)
                        const SpinKitFadingFour(
                          color: Colors.white,
                          size: 40.0,
                        ),
                      ],
                    )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    required bool enable,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextFormField(
        controller: controller,
        enabled: enable,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefixIcon),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
