import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_social/models/user_model.dart';
import 'package:flutter_social/services/database_service.dart';
import 'package:flutter_social/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/constants.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _name = '';
  String _bio = '';
  File? _profileImage;
  File? _coverImage;
  String? _imagePickedType;
  final _formKey = GlobalKey<FormState>();
  late bool _isLoading = false;

  displayCoverImage() {
    if (_coverImage == null) {
      if (widget.user.coverImage.isNotEmpty) {
        return NetworkImage(widget.user.coverImage);
      }
    } else {
      return FileImage(_coverImage!);
    }
  }

  displayProfileImage() {
    if (_profileImage == null) {
      if (widget.user.profilePicture.isEmpty) {
        return AssetImage('assets/anya.png');
      } else {
        return NetworkImage(widget.user.profilePicture);
      }
    } else {
      return FileImage(_profileImage!);
    }
  }

  saveProfile() async {
    _formKey.currentState?.save();
    if (_formKey.currentState!.validate() && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      String profilePictureUrl = '';
      String coverPictureUrl = '';
      if (_profileImage == null) {
        profilePictureUrl = widget.user.profilePicture;
      } else {
        profilePictureUrl = await StorageService.uploadProfilePicture(
            widget.user.profilePicture, _profileImage!);
      }
      if (_coverImage == null) {
        coverPictureUrl = widget.user.coverImage;
      } else {
        coverPictureUrl = await StorageService.uploadCoverPicture(
            widget.user.coverImage, _coverImage!);
      }
      UserModel user = UserModel(
        id: widget.user.id,
        name: _name,
        profilePicture: profilePictureUrl,
        bio: _bio,
        coverImage: coverPictureUrl,
        email: '',
      );

      DatabaseService.updateUserData(user);
      Navigator.pop(context);
    }
  }

  handleImageFromGallery() async {
    try {
      XFile? imageXFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      File imageFile = File(imageXFile!.path);
      if (_imagePickedType == 'profile') {
        setState(() {
          _profileImage = imageFile;
        });
      } else if (_imagePickedType == 'cover') {
        setState(() {
          _coverImage = imageFile;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          GestureDetector(
            onTap: () {
              _imagePickedType = 'cover';
              handleImageFromGallery();
            },
            child: Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: kocialColor,
                    image: _coverImage == null && widget.user.coverImage.isEmpty
                        ? null
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image: displayCoverImage(),
                          ),
                  ),
                ),
                Container(
                  height: 150,
                  color: Colors.black54,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 70,
                        color: Colors.white,
                      ),
                      Text(
                        'Change cover Photo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            transform: Matrix4.translationValues(0, -40, 0),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _imagePickedType = 'profile';
                        handleImageFromGallery();
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundImage: displayProfileImage(),
                          ),
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.black54,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Change Profile Photo',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {saveProfile()},
                      child: Container(
                        width: 100,
                        height: 35,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: kocialColor,
                        ),
                        child: Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      TextFormField(
                        initialValue: _name,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(color: kocialColor),
                        ),
                        validator: (input) => input!.trim().length < 2
                            ? 'Please enter valid name'
                            : null,
                        onSaved: (value) {
                          _name = value!;
                        },
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        initialValue: _bio,
                        decoration: InputDecoration(
                          labelText: 'Bio',
                          labelStyle: TextStyle(color: kocialColor),
                        ),
                        onSaved: (value) {
                          _bio = value!;
                        },
                      ),
                      const SizedBox(height: 30),
                      _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(kocialColor),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
