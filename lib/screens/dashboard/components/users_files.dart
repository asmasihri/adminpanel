import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parck_ease_admin_panel/List.dart';
import 'package:parck_ease_admin_panel/Person.dart';
import 'dart:html'
    as html; // Importation de la bibliothèque HTML pour Flutter web

import '../../../constants.dart';
import 'package:excel/excel.dart' as excel;

class RecentFiles extends StatefulWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  State<RecentFiles> createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles> {
  List<Person> people = [];
  List<Person> blocked = [];
  String _sortBy = 'Email';
  String _sortByusers = 'All';
  bool _isphone = false;

  List<Person> managers = [];
  List<Person> users = [];
  List<Person> isactiveliste = [];
  List<Person> isnotactive = [];

  String selectedType =
      'All'; // Ajoutez cette variable pour stocker le type sélectionné
  bool getIsActiveByEmail(String email, List<Person> people) {
    for (Person person in people) {
      if (person.email == email) {
        return person.isActive;
      }
    }
    return false; // Retourne false si l'email n'est pas trouvé
  }
  String formatDate(DateTime lastConnection) {
      final now = DateTime.now();
      final difference = now.difference(lastConnection);

      final days = difference.inDays;
      final hours = difference.inHours.remainder(24);

      return '$days jours, $hours heures';
    }

  bool getIsActiveByPhoneNumber(String phoneNumber, List<Person> people) {
    for (Person person in people) {
      if (person.phoneNumber == phoneNumber) {
        return person.isActive;
      }
    }
    return false; // Retourne false si le numéro de téléphone n'est pas trouvé
  }

  void exportToExcel(BuildContext context) {
    final excelFile = excel.Excel.createExcel();

    final sheet = excelFile['Sheet1'];
    sheet.appendRow(['UserName', 'Contact', 'Status', 'Last Connection']);

    for (final person in managers) {
          final lastConnection = person.lastConnection?.toDate(); // Convertir Timestamp en DateTime

      sheet.appendRow([
        person.name_gest,
        person.phoneNumber.isEmpty ? person.email : person.phoneNumber,
        person.isActive ? 'Active' : 'Pending',
      lastConnection != null ? formatDate(lastConnection) : 'N/A', // Vérifier si lastConnection est null
      ]);
    }
  
    final excelData = excelFile.encode();

    // Crée un objet blob pour le contenu du fichier Excel
    final blob = html.Blob([excelData]);

    // Crée un URL à partir du blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Crée un élément d'ancrage invisible pour le téléchargement du fichier

    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'parckease.xlsx')
      ..click(); // Déclenche le téléchargement

    // Libère l'URL et le blob pour éviter les fuites de mémoire
    html.Url.revokeObjectUrl(url);
  }

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
    blocked.clear() ; 

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        people = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String role = data['rool'] ?? '';
          bool isActive = data['isActive'] ?? false;
          String isblocked = data['isblocked'] ?? '';
          final userId = doc.id; // Récupérer l'ID du document Firebase

          Person person = Person(
              userId: userId,
              isblocked: isblocked,
              lastConnection: data['last_connection'],
              name_gest: data['name_gest'] ?? '',
              name_user: data['name_user'] ?? '',
              phoneNumber: data['phone'] ?? '',
              email: data['email'] ?? '',
              photoUrl: data['BadgeImage'] ?? '',
              badgePhotoUrl: data['BadgeImage'] ?? '',
              nationalCardFrontUrl: data['carteverso'] ?? '',
              nationalCardBackUrl: data['carterecto'] ?? '',
              isActive: isActive,
              pickpark: data['picpark'] ?? '',
              adress: data['adress'] ?? '',
              nombretotale: data['nombre_totale'] ?? '',
              nombrevide: data['nombre_vide'] ?? '',
              nameparking: data['name_parking'] ?? '' );

          if (role == 'Gestionnaire') {

              if (isblocked == '') {
                 managers.add(person);
                
              }            if (isActive) {
              isactiveliste.add(person);
            } else {
              if (isblocked== 'bloqué') {
                blocked.add(person);
                
              } 
              if (isblocked == '') {
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
              Material(
                child: DropdownButton<String>(
                  value: _sortByusers,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _sortByusers = newValue;
                        selectedType =
                            newValue; // Mettez à jour le type sélectionné
                      });
                    }
                  },
                  items: <String>[
                    'All',
                    'Users',
                    'Managers',
                    'Managers Pending',
                    'Managers Active', 
                    'Blocked'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Material(
                child: DropdownButton<String>(
                  value: _sortBy,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _sortList(newValue);
                    }
                  },
                  items: <String>['Email', 'Phone Number', 'Email/PhoneNumber']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  exportToExcel(context);
                },
                child: Icon(
                  Icons.expand_circle_down_outlined,
                  color: Color(0xFFEE2727),
                ),
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

  String getDisplayText(Person person) {
    if (_sortBy == 'Phone Number') {
      return person.phoneNumber;
    } else if (_sortBy == 'Email') {
      return person.email;
    } else {
      return person.phoneNumber.isNotEmpty ? person.phoneNumber : person.email;
    }
  }

  String getName(Person person) {
    if (person.name_gest.isEmpty) {
      return person.name_user;
    }
    return person.name_gest;
  }

  List<Person> filterUsersByEmailOrPhoneNumber(List<Person> users) {
    return users.where((user) {
      if (_sortBy == 'Phone Number') {
        return user.phoneNumber.isNotEmpty;
      } else if (_sortBy == 'Email') {
        return user.email.isNotEmpty;
      } else {
        // 'Phone Number/Email'
        return user.phoneNumber.isNotEmpty || user.email.isNotEmpty;
      }
    }).toList();
  }

  List<DataRow> _buildDataRows() {
    List<Person> filteredUsers = filterUsersByEmailOrPhoneNumber(people);

    List<DataRow> rows = [];
    if (selectedType == 'All') {
      rows = filteredUsers.map((Person person) {
        return DataRow(cells: [
          DataCell(Text(getName(person))),
          DataCell(Text(
            getDisplayText(person),
          )),
        ]);
      }).toList();
    } else if (selectedType == 'Managers') {
      List<Person> filteredUsers = filterUsersByEmailOrPhoneNumber(managers);

      rows = filteredUsers.map((Person user) {
        return DataRow(cells: [
          DataCell(Text(getName(user))),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(getDisplayText(user)),
              Spacer(),
              Container(
                child: Row(
                  children: [
                    Text(
                      user.isActive ? 'Active' : 'Pending',
                      style: TextStyle(
                        color: user.isActive
                            ? Color(0xFF26E5FF)
                            : Color(0xFFEE2727),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.001,
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToPersonDetailsScreen(user);
                      },
                      child: Icon(Icons.info,
                          color: Color(
                              0xFFEE2727)), // Ajoutez un icône ou un texte pour indiquer que c'est un détail
                    ),
                  ],
                ),
              )
            ],
          )),
        ]);
      }).toList();
    } else if (selectedType == 'Blocked') {
      List<Person> filteredUsers = filterUsersByEmailOrPhoneNumber(blocked);

      rows = filteredUsers.map((Person user) {
        return DataRow(cells: [
          DataCell(Text(getName(user))),
          DataCell(Text(getDisplayText(user))),
        ]);
      }).toList();
    }else if (selectedType == 'Managers Active') {
      List<Person> filteredUsers =
          filterUsersByEmailOrPhoneNumber(isactiveliste);

      rows = filteredUsers.map((Person user) {
        return DataRow(cells: [
          DataCell(Text(getName(user))),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(getDisplayText(user)),
              Spacer(),
              Container(
                child: Row(
                  children: [
                    Text(
                      user.isActive ? 'Active' : 'Pending',
                      style: TextStyle(
                        color: user.isActive
                            ? Color(0xFF26E5FF)
                            : Color(0xFFEE2727),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.001,
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToPersonDetailsScreen(user);
                      },
                      child: Icon(Icons.info,
                          color: Color(
                              0xFFEE2727)), // Ajoutez un icône ou un texte pour indiquer que c'est un détail
                    ),
                  ],
                ),
              )
            ],
          )),
        ]);
      }).toList();
    } else if (selectedType == 'Users') {
      List<Person> filteredUsers = filterUsersByEmailOrPhoneNumber(users);

      rows = filteredUsers.map((Person person) {
        return DataRow(cells: [
          DataCell(Text(getName(person))),
          DataCell(Text(getDisplayText(person))),
        ]);
      }).toList();
    } else {
      List<Person> filteredUsers = filterUsersByEmailOrPhoneNumber(isnotactive);

      rows = filteredUsers.map((Person user) {
        return DataRow(cells: [
          DataCell(Text(getName(user))),
          DataCell(Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(getDisplayText(user)),
              Spacer(),
              Container(
                child: Row(
                  children: [
                    Text(
                      user.isActive ? 'Active' : 'Pending',
                      style: TextStyle(
                        color: user.isActive
                            ? Color(0xFF26E5FF)
                            : Color(0xFFEE2727),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.001,
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToPersonDetailsScreen(user);
                      },
                      child: Icon(Icons.info,
                          color: Color(
                              0xFFEE2727)), // Ajoutez un icône ou un texte pour indiquer que c'est un détail
                    ),
                  ],
                ),
              )
            ],
          )),
        ]);
      }).toList();
    }

    return rows;
  }
}
