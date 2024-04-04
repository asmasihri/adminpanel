import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parck_ease_admin_panel/Person.dart';
import 'package:parck_ease_admin_panel/constants.dart';
import 'package:photo_view/photo_view.dart';

class PersonDetailsScreen extends StatefulWidget {
  final Person person;

  const PersonDetailsScreen({Key? key, required this.person}) : super(key: key);

  @override
  State<PersonDetailsScreen> createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  late ReloadBloc _reloadBloc;

  @override
  void initState() {
    super.initState();
    _reloadBloc = ReloadBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.name_gest),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await _updateUserStatus(true , false );
            },
            child: Text(
              'Accept',
              style: TextStyle(color: Color(0xFF26E5FF)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _updateUserStatus(false , true);
            },
            child: Text(
              'Refuse',
              style: TextStyle(color: Color.fromARGB(198, 232, 72, 8)),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            bool isNarrowScreen = constraints.maxWidth < 600;

            return isNarrowScreen
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInfoTexts(),
                      _buildImageCard(widget.person.badgePhotoUrl),
                      _buildImageCard(widget.person.nationalCardFrontUrl),
                      _buildImageCard(widget.person.nationalCardBackUrl),
                      _buildImageCard(widget.person.pickpark),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoContactTexts(),
                          _buildImageCard(widget.person.badgePhotoUrl),
                                                    _buildImageCard(widget.person.pickpark),

                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoTexts(),
                          _buildImageCard(widget.person.nationalCardBackUrl),
                          _buildImageCard(widget.person.nationalCardFrontUrl),
                        ],
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Widget _buildImageCard(String imageUrl) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: _buildZoomableImage(imageUrl),
      ),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
    );
  }

  Widget _buildInfoTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.person.nameparking),
        Text(widget.person.adress),
        Text(
          'Total Places: ${widget.person.nombretotale}',
          style: TextStyle(color: Color(0xFF26E5FF)),
        ),
        Text('Empty Places: ${widget.person.nombrevide}',
            style: TextStyle(
              color: Color.fromARGB(255, 225, 34, 27),
            )),
      ],
    );
  }

  Widget _buildInfoContactTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.person.name_gest),
        Text(widget.person.email),
        Text(widget.person.phoneNumber),
      ],
    );
  }

  Widget _buildZoomableImage(String imageUrl) {
    return Container(
      // double heightt = MediaQuery.of(context).size.height,
      // width: MediaQuery.of(context).size.width,
      height: 200,
      width: 300,
      child: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2.0,
        initialScale: PhotoViewComputedScale.contained,
        backgroundDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
      ),
    );
  }

  Future<void> _updateUserStatus(bool isActive  , bool block ) async {
    try {
    block ?  await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.person.userId)
          .update({'isActive': isActive  , 'isblocked' : 'bloqué' }) :
          await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.person.userId)
          .update({'isActive': isActive   }) 
          
          
           ;



      _reloadBloc.reload(); // Trigger event to reload the page
      Navigator.pop(context, true);
    } catch (error) {
      print("Error updating user isActive: $error");
    }
  }
}

class ReloadBloc {
  final _reloadController = StreamController<bool>.broadcast();

  Stream<bool> get reloadStream => _reloadController.stream;

  void reload() {
    _reloadController.add(true);
  }

  void dispose() {
    _reloadController.close();
  }
}
