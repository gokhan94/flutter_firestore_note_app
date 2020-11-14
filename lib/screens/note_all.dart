import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/api/data.dart';
import 'package:flutter_note_app/model/note.dart';
import 'note_detail.dart';

class NoteAll extends StatefulWidget {
  static const routeName = '/note_all';
  @override
  _NoteAllState createState() => _NoteAllState();
}

class _NoteAllState extends State<NoteAll> {
  final FirestoreDatabase firebaseInstance = FirestoreDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade300,
      appBar: AppBar(
        title: Text('Note All'),
        backgroundColor: Colors.blueGrey.shade600,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseInstance.streamNoteGet(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              if (document.data().isNotEmpty) {
                final descriptionStr = document.data()['description'];

                return Container(
                  height: 150,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, NoteDetail.routeName,
                          arguments: Note(
                              document.id,
                              document.data()['name'],
                              document.data()['description'],
                              document.data()['categoryId'],
                              document.data()['categoryName'],
                              document.data()['date']
                          )
                      );
                    },
                    child: Card(
                      color: Colors.blueGrey.shade900,
                      elevation: 20.0,
                      margin: EdgeInsets.all(5),
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
                              style: TextStyle( color: Colors.white70,
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            leading: Icon(
                              Icons.event_note,
                              size: 30,
                              color: Colors.white,
                            ),
                            subtitle: Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                descriptionStr.toString().length > 40
                                    ? descriptionStr.toString().substring(0, 40) + " ... "
                                    : descriptionStr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            dense: true,
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade600,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0))),
                                    child: Text(
                                      document.data()['categoryName'],
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    )),
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
                  ),
                );
              } else {
                return Center(
                  child: Text('ok'),
                );
              }
            }).toList(),
          );
        },
      ),
    );
  }
}
