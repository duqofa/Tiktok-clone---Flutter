import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String profilePhoto;
  final String email;
  final String uid;

  User({
    required this.name,
    required this.profilePhoto,
    required this.email,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "profilePhoto": profilePhoto,
        "email": email,
        "uid": uid,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      name: snapshot['name'],
      profilePhoto: snapshot['profilePhoto'],
      email: snapshot['email'],
      uid: snap['uid'],
    );
  }
}
