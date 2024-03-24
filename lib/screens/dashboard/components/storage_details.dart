import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'dart:async';

import 'storage_info_card.dart';

class Person {
  final String name;
  final String photoUrl;
  final String badgePhotoUrl; // Ajout du champ pour la photo du badge
  final String
      nationalCardFrontUrl; // Ajout du champ pour la carte nationale recto
  final String
      nationalCardBackUrl; // Ajout du champ pour la carte nationale verso
  bool isActive;
  final String role;
  final String phoneNumber;

  Person({
    required this.role,
    required this.phoneNumber,
    required this.name,
    required this.photoUrl,
    required this.badgePhotoUrl,
    required this.nationalCardFrontUrl,
    required this.nationalCardBackUrl,
    this.isActive = false,
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
    late Timer _timer;


  @override
  void initState() {
    super.initState();
_timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _fetchUsersFromFirestore();
    });  }
     @override
  void dispose() {
    // Arrête le timer lorsqu'il n'est plus nécessaire pour éviter les fuites de mémoire
    _timer.cancel();
    super.dispose();
  }


void _fetchUsersFromFirestore() async {
   managers.clear();
   people.clear();
   users.clear() ;
    isactiveliste.clear();
    isnotactive.clear();
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      people = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String role = data['rool'] ?? ''; // Récupérer le rôle de l'utilisateur
        bool isActive = data['isActive'] ?? false; // Récupérer le rôle de l'utilisateur
        Person person = Person(
          name: data['name'] ?? '',
          phoneNumber: data['phone'],
          photoUrl: data['imageUrl'] ?? '',
          badgePhotoUrl: data['imageUrl'] ?? '',
          nationalCardFrontUrl: data['imageUrl'] ?? '',
          nationalCardBackUrl: data['imageUrl'] ?? '',
          role: role,
          isActive: data['isActive'] ?? false,
        );

        if (role == 'Gestionnaire') {
          managers.add(person); // Ajouter l'utilisateur à la liste des gestionnaires
             if (isActive == true) {
          isactiveliste.add(person); // Ajouter l'utilisateur à la liste des gestionnaires
        }
  
          else {
          isnotactive.add(person); // Ajouter l'utilisateur à la liste des gestionnaires
        }
        }else{
          users.add(person) ;
        }
       
        return person;
      }).toList();
   
      print('people');
      print(people);
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
          Text(
            "Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          StorageInfoCard(
            svgSrc: "assets/icons/Documents.svg",
            title: 'Total Users',
            amountOfFiles: ' ${users.length.toString()}',
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/media.svg",
            title: "Total Managers",
            amountOfFiles: ' ${managers.length.toString()}',
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/folder.svg",
            
            title: "Verified Managers",
            amountOfFiles: ' ${isactiveliste.length.toString()}',
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/unknown.svg",
            title: "Pending Managers",
            amountOfFiles: ' ${isnotactive.length.toString()}',
          ),
        ],
      ),
    );
  }
}
