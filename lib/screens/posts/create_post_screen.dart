import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_social/Constants/Constants.dart';
import 'package:flutter_social/models/post.dart';
import 'package:flutter_social/Services/database_service.dart';
import 'package:flutter_social/Services/storage_service.dart';
import 'package:flutter_social/Widgets/RoundedButton.dart';

class CreatePostScreen extends StatefulWidget {
  final String currentUserId;

  const CreatePostScreen({Key? key,required this.currentUserId}) : super(key: key);
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late String _postText;
  File? _pickedImage;
  bool _loading = false;

  handleImageFromGallery() async {
    try {
      XFile? imageXFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      File imageFile = File(imageXFile!.path);
      if (imageFile != null) {
        setState(() {
          _pickedImage = imageFile;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kocialColor,
        centerTitle: true,
        title: Text(
          'Tweet',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              maxLength: 280,
              maxLines: 7,
              decoration: InputDecoration(
                hintText: 'Enter your Tweet',
              ),
              onChanged: (value) {
                _postText = value;
              },
            ),
            SizedBox(height: 10),
            _pickedImage == null
                ? SizedBox.shrink()
                : Column(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: kocialColor,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(_pickedImage!),
                      )),
                ),
                SizedBox(height: 20),
              ],
            ),
            GestureDetector(
              onTap: handleImageFromGallery,
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(
                    color: kocialColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 50,
                  color: kocialColor,
                ),
              ),
            ),
            SizedBox(height: 20),
            RoundedButton(
              btnText: 'Tweet',
              onBtnPressed: () async {
                setState(() {
                  _loading = true;
                });
                if (_postText != null && _postText!.isNotEmpty) {
                  String image;
                  if (_pickedImage == null) {
                    image = '';
                  } else {
                    image =
                    await StorageService.uploadPostPicture(_pickedImage!);
                  }
                  Post post = Post(
                    text: _postText,
                    image: image,
                    auhorId: widget.currentUserId,
                    likes: 0,
                    shares: 0,
                    timestamp: Timestamp.fromDate(
                      DateTime.now(),
                    ),
                  );
                  DatabaseService.createPost(post);
                  Navigator.pop(context);
                }
                setState(() {
                  _loading = false;
                });
              },
            ),
            SizedBox(height: 20),
            _loading ? CircularProgressIndicator() : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}