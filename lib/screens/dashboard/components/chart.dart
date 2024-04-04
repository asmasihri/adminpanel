import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:parck_ease_admin_panel/constants.dart';

class Person {
  final String name;
  final String photoUrl;
  final String badgePhotoUrl;
  final String nationalCardFrontUrl;
  final String nationalCardBackUrl;
  bool isActive;
  final String phoneNumber;
  String isblocked;

  Person({
    this.isblocked = '',
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
  List<Person> users = [];
  List<Person> managers = [];
  List<Person> isactiveliste = [];
  List<Person> isnotactive = [];
  List<Person> bloqued = [];

  @override
  void initState() {
    super.initState();
    _fetchUsersFromFirestore();
  }

  void _fetchUsersFromFirestore() async {
    managers.clear();
    users.clear();
    isactiveliste.clear();
    isnotactive.clear();
    bloqued.clear();

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String role = data['rool'] ?? '';
          String isblocked = data['isblocked'] ?? '';
          bool isActive = data['isActive'] ?? false;

          Person person = Person(
            phoneNumber: data['phone'] ?? '',
            name: data['name_gest'] ?? '',
            isblocked: isblocked,
            photoUrl: data['BadgeImage'] ?? '',
            badgePhotoUrl: data['BadgeImage'] ?? '',
            nationalCardFrontUrl: data['CarteRecto'] ?? '',
            nationalCardBackUrl: data['carteverso'] ?? '',
            isActive: isActive,
          );

           if (role == 'Gestionnaire') {

              if (isblocked == '') {
                 managers.add(person);
                
              }            if (isActive) {
              isactiveliste.add(person);
            } else {
              if (isblocked== 'bloqué') {
                bloqued.add(person);
                
              } 
              if (isblocked == '') {
                 isnotactive.add(person);
                
              }
             
            }
          }
          if (role == '') {
            users.add(person);
          }
        });

        print('Active Managers: ${isactiveliste.length}');
        print('Inactive Managers: ${isnotactive.length}');
      });
    } catch (error) {
      print("Error fetching users: $error");
    }
  }

//
  @override
  Widget build(BuildContext context) {
    int activeManagersCount = isactiveliste.length;
    int inactiveManagersCount = isnotactive.length;
    int toutalusers = users.length;
    int isblockedd = bloqued.length;
    int totalUsersCount =
        (activeManagersCount + inactiveManagersCount + toutalusers);

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              
              sections: [
                PieChartSectionData(
                  color: Color(0xFF26E5FF),
                  value: activeManagersCount.toDouble(),
                  showTitle: false,
                  radius: 19,
                ),
                PieChartSectionData(
                  color: Color.fromARGB(255, 176, 90, 29),
                  value: inactiveManagersCount.toDouble(),
                  showTitle: false,
                  radius: 16,
                ),
                PieChartSectionData(
                  color: primaryColor.withOpacity(0.1),
                  value: totalUsersCount.toDouble(),
                  showTitle: false,
                  radius: 13,
                ),
                PieChartSectionData(
                  color: Color(0xFFEE2727),
                  value: isblockedd.toDouble(),
                  showTitle: false,
                  radius: 10,
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  'Active Managers: $activeManagersCount\nInactive Managers: $inactiveManagersCount',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
