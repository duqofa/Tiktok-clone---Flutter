import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/controllers/auth_controller.dart';
import 'package:tiktok_clone/views/screens/add_video_screen.dart';
import 'package:tiktok_clone/views/screens/video_screen.dart';

// Pages
const pages = [
  VideoScreen(),
  Text(
    'Search screen',
    style: TextStyle(color: Colors.black),
  ),
  AddVideoScreen(),
  Text(
    'Message screen',
    style: TextStyle(color: Colors.black),
  ),
  Text(
    'Profile screen',
    style: TextStyle(color: Colors.black),
  ),
];

// Colors
const backgroundColor = Colors.black;
const borderColor = Colors.grey;
var buttonColor = Colors.red[400];

// Firebase
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firebaseFirestore = FirebaseFirestore.instance;

// Controllers
var authController = AuthController.instance;
