import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:black_coffer/video_desc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class VideoController {
  late Position currentPosition;
  late String currentAddress;
  late String localpath;

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ignore: avoid_print
      print('Please enable Your Location Service');
      Fluttertoast.showToast(
        msg: 'Please enable Your Location Service',
        backgroundColor: Colors.grey,
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: avoid_print
        print('Location permissions are denied');
        Fluttertoast.showToast(
          msg: 'Location permissions are denied',
          backgroundColor: Colors.grey,
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // ignore: avoid_print
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
      // ignore: avoid_print
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );
      Placemark place = placemarks[0];
      currentAddress =
          "${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  final ImagePicker picker = ImagePicker();

  Future<void> pickVideo(BuildContext context, String phonenumber) async {
    final XFile? video = await picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      try {
        localpath = video.path;
        await uploadVideoToDatabase(File(video.path), phonenumber, context);
      } catch (e) {
        print('Error adding document: $e');
      }
    } else {}
  }

  Future<void> uploadVideoToDatabase(
    File file,
    String phonenumber,
    BuildContext context,
  ) async {
    var uuid = const Uuid();
    var fileName = uuid.v1();
    var storageRef = FirebaseStorage.instance.ref().child("Video/$fileName");

    try {
      await _determinePosition(); // wait for position determination

      String receiveAddress = currentAddress;
      print('MY address: $receiveAddress');

      var uploadTask = storageRef.putFile(file);
      await uploadTask.whenComplete(() async {
        String downloadURL = await storageRef.getDownloadURL();

        //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
        //   await _firestore.collection('client').doc(phonenumber).set({
        //     'videoPath': downloadURL,
        //     'address': receiveAddress,
        //     // Add other fields as needed
        //   });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Videod(
              videoPath: downloadURL,
              phonenumber: phonenumber,
              address: receiveAddress,
              localpath: localpath,
            ),
          ),
        );
      });
    } catch (error) {
      // ignore: avoid_print
      print("Error uploading video: $error");
    }
  }
}
