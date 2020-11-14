import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/api/data.dart';
import 'package:flutter_note_app/model/note.dart';

import 'note_detail.dart';

class CategoryNoteDetail extends StatefulWidget {
  static const routeName = '/category-detail';
  String id;
  String name;
  CategoryNoteDetail();
  CategoryNoteDetail.category({this.id, this.name});

  @override
  _CategoryNoteDetailState createState() => _CategoryNoteDetailState();
}

class _CategoryNoteDetailState extends State<CategoryNoteDetail> {
  final FirestoreDatabase collectionNote = FirestoreDatabase();

  @override
  Widget build(BuildContext context) {
    final CategoryNoteDetail categoryData =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
        backgroundColor: Colors.blueGrey.shade300,
        appBar: AppBar(
          title: Text("${categoryData.name} Categories"),
          backgroundColor: Colors.blueGrey.shade600,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: collectionNote.streamNoteGet(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                if (document.data()['categoryId'] == categoryData.id) {
                  final descriptionStr = document.data()['description'];
                  return Container(
                    height: 150,
                    child: Card(
                      color: Colors.blueGrey.shade900,
                      elevation: 10,
                      margin: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular((10.0)),
                          side: BorderSide(
                              color: Colors.grey.shade400, width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(
                            title: Text(
                              document.data()['name'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70),
                            ),
                            leading: Icon(Icons.note, color: Colors.white, size: 30,),
                            subtitle: Text(
                              descriptionStr.toString().length > 40
                                  ? descriptionStr.toString().substring(0, 40) + " ... "
                                  : descriptionStr,
                              style: TextStyle(fontSize: 18,  color: Colors.white,),
                            ),
                            dense: true,
                            onTap: () {
                              _showDialog(
                                  context,
                                  document.id,
                                  document.data()['name'],
                                  document.data()['description'],
                                  document.data()['categoryId'],
                                  document.data()['categoryName'],
                                  document.data()['date']);
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  document.data()['date'],
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white54,),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }).toList(),
            );
          },
        ));
  }

  _showDialog(BuildContext context, String id, String name,
      String description, String categoryId, String categoryName, String date) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                "Note Settings",
                style: TextStyle(fontSize: 18),
              ),
              content: Text(
                "Are you sure you want to delete the note ?",
                style: TextStyle(fontSize: 18),
              ),
              actions: [
                Row(
                  children: [
                    FlatButton(
                      textColor: Color(0xFFF00044),
                      child: Text(
                        "Delete Note",
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () async {
                        await collectionNote.deleteNote(id);
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      textColor: Colors.blueGrey.shade800,
                      child: Text(
                        'Note Detail',
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, NoteDetail.routeName,
                            arguments: Note(id, name, description, categoryId, categoryName, date));

                      },
                    ),
                    FlatButton(
                      textColor: Colors.blueGrey.shade800,
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],

        )
    );
  }
}
