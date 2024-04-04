import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parck_ease_admin_panel/constants.dart';
import 'package:parck_ease_admin_panel/responsive.dart';
import 'package:parck_ease_admin_panel/screens/dashboard/components/header.dart';

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
    child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centers vertically in the column
          children: [
            Header(
              issupport: true,
            ),
            SizedBox(height: defaultPadding),
            Responsive.isMobile(context)
                ? ContainerSupport() // If mobile, display without wrapping in Expanded
                : ContainerSupport(),
          ],
        ),
      ),  );
  }
}


class ContainerSupport extends StatefulWidget {
  @override
  State<ContainerSupport> createState() => _ContainerSupportState();
}

class _ContainerSupportState extends State<ContainerSupport> {
   String phoneNumber = "";
void _getPhoneNumberFromFirestore() async {

  try {
    // Effectuez une requête pour obtenir les données de la collection 'phoneNumbers'
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('phoneNumbers').get();

    // Vérifiez s'il y a des documents dans le résultat de la requête
    if (querySnapshot.docs.isNotEmpty) {
      // Récupérez le premier document (s'il y en a plusieurs, vous pouvez adapter cette logique)
      Map<String, dynamic>? phoneNumberData = querySnapshot.docs.first.data() as Map<String, dynamic>?;

      // Vérifiez si le document contient la clé 'phoneNumber'
      if (phoneNumberData != null && phoneNumberData.containsKey('phoneNumber')) {
        setState(() {
          phoneNumber = phoneNumberData['phoneNumber'];
        });
      }
    }
  } catch (error) {
    // Gérez les erreurs éventuelles lors de la récupération des données depuis Firestore
    
    print('Error retrieving phone number: $error');
  }
}
 

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPhoneNumberFromFirestore() ; 
  }
 
 
 
 
 @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    void _showSupportDialog() {
      TextEditingController phoneController = TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Phone Number WhatsApp of your support'),
            content: TextField(
              controller: phoneController,
              decoration: InputDecoration(
                hintText: 'Enter Phone Number here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF26E5FF), // Use backgroundColor instead of primary
                ),
                child: Text('Save' , style: TextStyle(
                  color: bgColor , 
                ),),
                 onPressed: () {
                  String enteredPhoneNumber = phoneController.text.trim();
                  if (enteredPhoneNumber.isNotEmpty) {
                    // Mettez à jour la variable phoneNumber
  setState(() {
                      phoneNumber = enteredPhoneNumber;
                    });
                    // Ajoutez le numéro de téléphone à Firestore
                    FirebaseFirestore.instance.collection('phoneNumbers').add({
                      'phoneNumber': phoneNumber,
                      'timestamp': DateTime.now(),
                    });

                    // Fermez le dialogue
                    Navigator.of(context).pop();
                  } else {
                    // Affichez un message d'erreur si le numéro de téléphone est vide
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Please enter a phone number.'),
                      ),
                    );
                  }
                                  }
              ),
            ],
          );
        },
      );
    }

    // Styling
    var cardTextStyle = TextStyle(
      color: Color(0xFF26E5FF),
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    var phoneNumberStyle = TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );

    return Center(
      child: Padding(
        padding:  EdgeInsets.only(top: height *0.2),
        child: Container(
          height: height * 0.25,
          width: width * 0.4,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [secondaryColor.withOpacity(0.3), secondaryColor],
              // colors: [Color(0xFF26E5FF), secondaryColor],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Phone Number WhatsApp',
                style: cardTextStyle,
              ),
              SizedBox(height: defaultPadding),
              Container(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  phoneNumber,
                  style: phoneNumberStyle,
                ),
              ),
              SizedBox(height: defaultPadding * 2),
              ElevatedButton(
                onPressed: _showSupportDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF26E5FF), // Corrected parameter here
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}