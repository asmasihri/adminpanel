import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parck_ease_admin_panel/List.dart';
import 'package:parck_ease_admin_panel/Person.dart';

import '../../../constants.dart';

class RecentFiles extends StatefulWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  State<RecentFiles> createState() => _RecentFilesState();
}
class _RecentFilesState extends State<RecentFiles> {
  List<Person> people = [];
  String _sortBy = 'Email';
  String _sortByusers = 'All';
  bool _isphone = false;
  

  List<Person> managers = [];
  List<Person> users = [];
  List<Person> isactiveliste = [];
  List<Person> isnotactive = [];

  String selectedType = 'All'; // Ajoutez cette variable pour stocker le type sélectionné

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
    
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        people = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String role = data['rool'] ?? '';
          bool isActive = data['isActive'] ?? false;
            final userId = doc.id; // Récupérer l'ID du document Firebase

          Person person = Person(

            userId: userId,
            
            name: data['name'] ?? '',
            phoneNumber: data['phone'],
            photoUrl: data['BadgeImage'] ?? '',
            badgePhotoUrl: data['BadgeImage'] ?? '',

            nationalCardFrontUrl: data['CarteRecto'] ?? '',
            nationalCardBackUrl: data['CarteVerso'] ?? '',
            isActive: isActive,
             pickpark:  data['picpark'] ?? '', 
             adress: data['adress'] ?? '',
             nameparking: data['name_parking'] ?? ''
               );

          if (role == 'Gestionnaire') {
            managers.add(person);
            if (isActive) {
              isactiveliste.add(person);
            } else {
              isnotactive.add(person);
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

  void _sortList(String newValue) {
    setState(() {
      _sortBy = newValue;
    });
  }
  void _navigateToPersonDetailsScreen(Person user) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PersonDetailsScreen(person: user),
    ),
  );
  if (result != null && result == true) {
     _fetchUsersFromFirestore();
    
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                value: _sortByusers,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _sortByusers = newValue;
                      selectedType = newValue; // Mettez à jour le type sélectionné
                    });
                  }
                },
                items: <String>['All', 'Users', 'Managers' , 'Managers Pending']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: _sortBy,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _sortList(newValue);
                  }
                },
                items: <String>['Email', 'Phone Number']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: [
                DataColumn(
                  label: Text("UserName"),
                ),
                DataColumn(
                  label: Text(
                    _isphone ? "Phonenumber" : "Email",
                  ),
                ),
                
                
                
              ],
              rows: _buildDataRows(),
            ),
          ),
       
        ],
      ),
    );
  }

  List<DataRow> _buildDataRows() {
    List<DataRow> rows = [];
    if (selectedType == 'All') {
      rows = people.map((Person person) {
        return DataRow(cells: [
          DataCell(Text(person.name)),
          DataCell(
            Text(
              person.phoneNumber
              )),
        ]);
      }).toList();
    } else if (selectedType == 'Managers') {
    rows = managers.map((Person user) {
  return DataRow(cells: [
    DataCell(Text(user.name)),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(user.phoneNumber),
          Text(
          user.isActive? 'Active' : 'Pending' , 
          style: TextStyle(
            color: user.isActive? Color(0xFF26E5FF) : Color(0xFFEE2727) ,
          ),

        ) ,
        GestureDetector(
          onTap: (){
                         _navigateToPersonDetailsScreen(user);

          },
          child: Icon(Icons.info,
                   color : Color(0xFFEE2727)

          ), // Ajoutez un icône ou un texte pour indiquer que c'est un détail
        ),
      ],
    )),
  ]);
}).toList();

   
   
    } else if(selectedType == 'Users') {
        rows = users.map((Person person) {
        return DataRow(cells: [
          DataCell(Text(person.name)),
          DataCell(Text(person.phoneNumber)),
        ]);
      }
      
      ).toList();
      } else{

         rows = isnotactive.map((Person user) {
  return DataRow(cells: [
    DataCell(Text(user.name)),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(user.phoneNumber),
        Text(
          user.isActive? 'Active' : 'Pending' , 

        ) ,
        GestureDetector(
          onTap: (){
           
                _navigateToPersonDetailsScreen(user);

          },
          child: Icon(Icons.info , 
         color : Color(0xFFEE2727)
          ), // Ajoutez un icône ou un texte pour indiquer que c'est un détail
        ),
      ],
    )),
  ]);
}).toList();

   

      }

    return rows;
  }
}
