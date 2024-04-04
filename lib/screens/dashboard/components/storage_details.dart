import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'dart:async';

import 'storage_info_card.dart';

class Person {
  bool isActive;
  final String role;
  final String phoneNumber;
  final String email;
  final String userId;
  final String nationalCardFrontUrl;
  final String nationalCardBackUrl;
  final String? isbloqued;

  Person({
    this.isbloqued,
    required this.email,
    required this.role,
    required this.phoneNumber,
    this.isActive = false,
    required this.userId,
    required this.nationalCardBackUrl,
    required this.nationalCardFrontUrl,
  });
}

class StorageDetails extends StatefulWidget {
  const StorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<StorageDetails> createState() => _StorageDetailsState();
}

class _StorageDetailsState extends State<StorageDetails> {
  List<Person> people = [];
  List<Person> users = [];
  List<Person> managers = [];
  List<Person> isactiveliste = [];
  List<Person> isnotactive = [];
  List<Person> bloqued = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _fetchUsersFromFirestore();
    });
  }

  @override
  void dispose() {
    // Arrête le timer lorsqu'il n'est plus nécessaire pour éviter les fuites de mémoire
    _timer.cancel();
    super.dispose();
  }

  void _fetchUsersFromFirestore() async {
    managers.clear();
    users.clear();
    isactiveliste.clear();
    bloqued.clear();
    isnotactive.clear();

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        people = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String role = data['rool'] ?? '';
          String isbloqued = data['isblocked'] ?? '';
          bool isActive = data['isActive'] ?? false;

          final userId = doc.id; // Récupérer l'ID du document Firebase

          Person person = Person(
            role: role,
            userId: userId,
            isbloqued: isbloqued,
            email: data['email'] ?? '',
            phoneNumber: data['email'] ?? '',
            isActive: isActive,
            nationalCardFrontUrl: data['CarteRecto'] ?? '',
            nationalCardBackUrl: data['carteverso'] ?? '',
          );

          if (role == 'Gestionnaire') {

              if (isbloqued == '') {
                 managers.add(person);
                
              }            if (isActive) {
              isactiveliste.add(person);
            } else {
              if (isbloqued== 'bloqué') {
                bloqued.add(person);
                
              } 
              if (isbloqued == '') {
                 isnotactive.add(person);
                
              }
             
            }
          }
          if (role == '') {
            users.add(person);
          }
          return person;
        }).toList();

        print('people');
        print(managers.length);
      });
    } catch (error) {
      print("Error fetching users: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          StorageInfoCard(
            svgSrc: primaryColor.withOpacity(0.1),
            title: 'Total ',
            amountOfFiles: ' ${people.length.toString()}',
          ),
          StorageInfoCard(
            svgSrc: bgColor,
            title: "Total Managers",
            amountOfFiles: ' ${managers.length.toString()}',
          ),
          StorageInfoCard(
            svgSrc: Color(0xFF26E5FF),
            title: "Verified Managers",
            amountOfFiles: ' ${isactiveliste.length.toString()}',
          ),
          StorageInfoCard(
            svgSrc: Color.fromARGB(255, 176, 90, 29),
            title: "Pending Managers",
            amountOfFiles: ' ${isnotactive.length.toString()}',
          ),
            StorageInfoCard(
            svgSrc: Color(0xFFEE2727),
            title: "Bloaqued Managers",
            amountOfFiles: ' ${bloqued.length.toString()}',
          ),
        ],
      ),
    );
  }
}
