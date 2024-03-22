import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class Person {
  final String name;
  final String photoUrl;
  final String badgePhotoUrl; // Ajout du champ pour la photo du badge
  final String
      nationalCardFrontUrl; // Ajout du champ pour la carte nationale recto
  final String
      nationalCardBackUrl; // Ajout du champ pour la carte nationale verso
  bool isActive;
    final String phoneNumber;


  Person({
        required this.phoneNumber,

    required this.name,
    required this.photoUrl,
    required this.badgePhotoUrl,
    required this.nationalCardFrontUrl,
    required this.nationalCardBackUrl,
    this.isActive = false,
  });
}

class Chart extends StatefulWidget {
  const Chart({
    Key? key,
  }) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
      List<Person> people = [];

  @override
  void initState() {
    super.initState();
    _fetchUsersFromFirestore();
  }

  void _fetchUsersFromFirestore() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        people = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Person(
            name: data['name'] ?? '',
            phoneNumber: data['phone'],
           photoUrl: data['imageUrl'] ?? '',
          badgePhotoUrl: data['imageUrl'] ?? '',
          nationalCardFrontUrl: data['imageUrl'] ?? '',
          nationalCardBackUrl: data['imageUrl'] ?? '',
          isActive: data['isActive'] ?? false,
          );

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
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: paiChartSelectionData,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: defaultPadding),
                Text(
                  '${people.length.toString()}',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                Text("Users")
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<PieChartSectionData> paiChartSelectionData = [
  PieChartSectionData(
    color: primaryColor,
    value: 25,
    showTitle: false,
    radius: 25,
  ),
  PieChartSectionData(
    color: Color(0xFF26E5FF),
    value: 20,
    showTitle: false,
    radius: 22,
  ),
  PieChartSectionData(
    color: Color(0xFFFFCF26),
    value: 10,
    showTitle: false,
    radius: 19,
  ),
  PieChartSectionData(
    color: Color(0xFFEE2727),
    value: 15,
    showTitle: false,
    radius: 16,
  ),
  PieChartSectionData(
    color: primaryColor.withOpacity(0.1),
    value: 25,
    showTitle: false,
    radius: 13,
  ),
];
