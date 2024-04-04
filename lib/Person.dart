import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  final String userId;
  final String name_gest;
  final String name_user;
  final String phoneNumber;
  final String photoUrl;
  final String badgePhotoUrl;
  final String nationalCardFrontUrl;
  final String nationalCardBackUrl;
  final String pickpark;
  final String adress;
  final String nameparking;
  bool isActive;
  final String email;
  final Timestamp? lastConnection; 
  final String ?nombretotale ; 
  final String ?nombrevide  ; 
  final String ?isblocked  ; 
  Person({
    this.isblocked ,
    this.nombrevide, 
    this.nombretotale ,
    required this.email,
    required this.pickpark,
    this.lastConnection,
    required this.adress,
    required this.nameparking,
    required this.name_gest,
    required this.name_user,
    required this.userId,
    required this.phoneNumber,
    required this.photoUrl,
    required this.badgePhotoUrl,
    required this.nationalCardFrontUrl,
    required this.nationalCardBackUrl,
    this.isActive = false,
  });
}
