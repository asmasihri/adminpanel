import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parck_ease_admin_panel/Person.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:parck_ease_admin_panel/constants.dart';
import 'package:parck_ease_admin_panel/screens/main/main_screen.dart';
import 'package:photo_view/photo_view.dart';



class PersonDetailsScreen extends StatefulWidget {
  final Person person;

  const PersonDetailsScreen({Key? key, required this.person}) : super(key: key);

  @override
  State<PersonDetailsScreen> createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(widget.person.name) ,
    Container(child: Row(
      children: [
        
    ElevatedButton(
      style: ButtonStyle(

backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
  if (states.contains(MaterialState.pressed)) {
    // Couleur lorsque le bouton est pressé
    return Color(0xFF26E5FF);
  }
  // Couleur par défaut
  return Color(0xFF26E5FF);
}),      ),
      
      onPressed: () async {
        setState(() {
          widget.person.isActive = true; // Marquer comme actif
        });

        // Mettre à jour la propriété isActive dans Firebase
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.person.userId)
              .update({'isActive': true});
              Navigator.pop(context , true) ; 

        } catch (error) {
          print("Error updating user isActive: $error");
          // Annuler les changements locaux si la mise à jour échoue
          setState(() {
            widget.person.isActive = false; // Revertir les changements locaux
          });
        }
      },
      child: Text('Accept', 
      style: TextStyle(
        color: Colors.black ,
      ),
      ),

    ),
    SizedBox(width: 20,) , 
   
    ElevatedButton(
      style: ButtonStyle(
             
backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
  if (states.contains(MaterialState.pressed)) {
    // Couleur lorsque le bouton est pressé
    return Color(0xFFEE2727);
  }
  // Couleur par défaut
  return Color(0xFFEE2727);
}),      ),
      
        
      
      
      onPressed: () async {
        setState(() {
          widget.person.isActive = false; // Marquer comme inactif
        });

        // Mettre à jour la propriété isActive dans Firebase
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.person.userId)
              .update({'isActive': false});
              Navigator.pop(context , true) ; 

        } catch (error) {
          print("Error updating user isActive: $error");
          // Annuler les changements locaux si la mise à jour échoue
          setState(() {
            widget.person.isActive = true; // Revertir les changements locaux
          });
        }
      },
      child: Text('Refuse'),
    ),
  
      ],

    ) ,)
   
  
  ],
)

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 18/8,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 0.8,
              ),
              items: [
                _buildZoomableImage(widget.person.badgePhotoUrl),
                _buildZoomableImage(widget.person.nationalCardFrontUrl),
                _buildZoomableImage(widget.person.nationalCardBackUrl),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomableImage(String imageUrl) {
    return Container(
      child: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2.0,
        initialScale: PhotoViewComputedScale.contained,
        backgroundDecoration:  BoxDecoration(
          color: Colors.transparent,
        ),
      ),
    );
  }
}





