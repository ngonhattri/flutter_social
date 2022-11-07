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

  const CreatePostScreen({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late String _postText;
  File? _pickedImage;
  final _text = TextEditingController();
  bool _loading = false;
  bool _validate = false;

  handleImageFromGallery() async {
    try {
      XFile? imageXFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      File imageFile = File(imageXFile!.path);
      setState(() {
        _pickedImage = imageFile;
      });
    } catch (e) {
      print(e);
    }
  }
  @override
  void initState() {
    _text.text = "";
    super.initState();
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kocialColor,
        centerTitle: true,
        title: const Text(
          'Post',
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
            const SizedBox(height: 20),
            TextField(
              controller: _text,
              maxLength: 280,
              maxLines: 7,
              decoration: InputDecoration(
                hintText: 'Enter your post',
                errorText: _validate ? 'Value Can\'t Be Empty' : null,
              ),
              onChanged: (value) {
                _postText = value;
              },
            ),
            const SizedBox(height: 10),
            _pickedImage == null
                ? const SizedBox.shrink()
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
                      const SizedBox(height: 20),
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
                child: const Icon(
                  Icons.camera_alt,
                  size: 50,
                  color: kocialColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            RoundedButton(
              btnText: 'Post',
              onBtnPressed: () async {
                setState(() {
                  _text.text.isEmpty ? _validate = true : _validate = false;
                });
                if (_postText.isNotEmpty) {
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
                  if (!mounted) return;
                  Navigator.of(context).pop();
                }
                setState(() {
                  _loading = false;
                });
              },
            ),
            const SizedBox(height: 20),
            _loading ? const CircularProgressIndicator() : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
