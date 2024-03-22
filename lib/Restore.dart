// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class Person {
//   final String name;
//   final String phoneNumber;
//   final String photoUrl;
//   final String badgePhotoUrl; // Ajout du champ pour la photo du badge
//   final String
//       nationalCardFrontUrl; // Ajout du champ pour la carte nationale recto
//   final String
//       nationalCardBackUrl; // Ajout du champ pour la carte nationale verso
//   bool isActive;

//   Person({
//     required this.name,
//     required this.phoneNumber,
//     required this.photoUrl,
//     required this.badgePhotoUrl,
//     required this.nationalCardFrontUrl,
//     required this.nationalCardBackUrl,
//     this.isActive = false,
//   });
// }

// class AdminPanelScreen extends StatefulWidget {
//   @override
//   _AdminPanelScreenState createState() => _AdminPanelScreenState();
// }

// class _AdminPanelScreenState extends State<AdminPanelScreen> {
//   List<Person> people = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchUsersFromFirestore();
//   }

//   void _fetchUsersFromFirestore() async {
//     try {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('users').get();
//       setState(() {
//         people = querySnapshot.docs.map((doc) {
//           Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//           return Person(
//             name: data['name'],
//             phoneNumber: data['phone'],
//             photoUrl: data['imageUrl'],
//             badgePhotoUrl: data['imageUrl'],
//             nationalCardFrontUrl: data['imageUrl'],
//             nationalCardBackUrl: data['imageUrl'],
//             isActive: data['isActive'] ?? false,
//           );
//         }).toList();
//       });
//     } catch (error) {
//       print("Error fetching users: $error");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Panel'),
//       ),
//       body: ListView.builder(
//         itemCount: people.length,
//         itemBuilder: (context, index) {
//           final person = people[index];
//           return ListTile(
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage(person.photoUrl),
//             ),
//             title: Text(person.name),
//             subtitle: Text(person.phoneNumber),
//             trailing: IconButton(
//               icon: Icon(
//                   person.isActive ? Icons.check_circle : Icons.remove_circle),
//               onPressed: () {
//                 setState(() {
//                   person.isActive = !person.isActive;
//                 });
//               },
//             ),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PersonDetailsScreen(person: person),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class PersonDetailsScreen extends StatelessWidget {
//   final Person person;

//   const PersonDetailsScreen({Key? key, required this.person}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(person.name),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Afficher la photo du badge dans un container avec une marge inférieure
//             Container(
//               height: 400,
//               width: 300,
//               margin: EdgeInsets.only(bottom: 10.0),
//               child: Image.network(person.badgePhotoUrl),
//             ),
//             // Afficher la carte nationale recto dans un container avec une marge inférieure
//             Divider(
//               color: Colors.black,
//               height: 10,
//             ),
//             Container(
//               height: 400,
//               width: 300,
//               margin: EdgeInsets.only(bottom: 10.0),
//               child: Image.network(person.nationalCardFrontUrl),
//             ),
//             Divider(
//               color: Colors.black,
//               height: 10,
//             ),
//             // Afficher la carte nationale verso dans un container
//             Container(
//               height: 400,
//               width: 300,
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: NetworkImage(person.nationalCardBackUrl))),
//                         child: ErrorWidget('Failed to load image'),

//             ),

//           ],
//         ),
//       ),
//     );
//   }
// }
