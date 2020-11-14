import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/api/data.dart';
import 'package:flutter_note_app/model/category.dart';
import 'package:flutter_note_app/screens/note_add.dart';
import 'package:flutter_note_app/screens/note_all.dart';
import 'package:flutter_note_app/ui/category_add.dart';
import 'category_detail.dart';
import 'package:flutter_note_app/screens/category_note_detail.dart';

class NoteHomePage extends StatefulWidget {
  static const routeName = '/home';
  @override
  _NoteHomePageState createState() => _NoteHomePageState();
}

class _NoteHomePageState extends State<NoteHomePage> {
  final FirestoreDatabase firebaseInstance = FirestoreDatabase();
  final Category category = Category();
   var totalCategories;
   var totalNotes;

    @override
  void initState(){
      getCategoryDataStream();
      getNoteDataStream();
    super.initState();
  }

  getCategoryDataStream() {
    return firebaseInstance.collectionCategory.snapshots().listen((snap) {
      setState(() {
        totalCategories = snap.docs.length.toString();
      });
    });
  }

  getNoteDataStream() {
    return firebaseInstance.collectionNote.snapshots().listen((snap) {
      setState(() {
        totalNotes = snap.docs.length.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade600,
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(Icons.event_note, size: 30,),
        title: Text("Note Keeper"),
        backgroundColor: Colors.blueGrey.shade600,
        elevation: 20.0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30,
            onPressed: () async {
              Navigator.pushNamed(context, CategoryAdd.routeName);
            },
          ),
        ],
      ),
      body: Column(
        children: [

          categoryScrollView(),

          Divider(color: Colors.white38,  thickness: 2, indent: 25, endIndent: 25,),

          Expanded(
            child: Container(
              margin: EdgeInsets.all(5),
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(15),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade900,
                      borderRadius: BorderRadius.all(
                          Radius.circular(35.0),
                      ),
                      boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))],
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.note, size: 50, color: Colors.white,),
                       Text(" ${totalNotes.toString()} Notes",  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 16),),

                      ],
                    ),
                    //color: Colors.teal[100],
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade900,
                      borderRadius: BorderRadius.all(
                        Radius.circular(35.0),
                      ),
                      boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))],
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.category, size: 50, color: Colors.white,),
                        Text("${totalCategories.toString()} Categories", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 16),),

                      ],
                    ),
                    //color: Colors.teal[100],
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, NoteAll.routeName);
                    },
                    child: Container(
                      padding:  EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade900,
                        borderRadius: BorderRadius.all(
                          Radius.circular(35.0),
                        ),
                        boxShadow: [BoxShadow(blurRadius: 5,color: Colors.black,offset: Offset(1,3))],
                      ),
                      child:  Column(
                        children: [
                          Icon(Icons.note, size: 50, color: Colors.white,),
                          Text("All Notes",style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 16),),

                        ],
                      ),

                      //color: Colors.teal[100],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, CategoryDetail.routeName);
                    },
                    child: Container(
                      padding:  EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade900,
                        borderRadius: BorderRadius.all(
                          Radius.circular(35.0),
                        ),
                        boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))],
                      ),
                      child:  Column(
                        children: [
                          Icon(Icons.category, size: 50, color: Colors.white,),
                          Text("All Categories", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 16),),
                        ],
                      ),
                      //color: Colors.teal[100],
                    ),
                  ),
                ],
              )
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black45,
        onPressed: (){
          Navigator.pushNamed(context, NoteAdd.routeName);
        },
        child: Icon(Icons.add_to_photos),
      ),
    );
  }

  Widget categoryScrollView() {
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseInstance.streamCategoryGet(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        return Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return categoryFlatButton(document);
                  }).toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget categoryFlatButton(DocumentSnapshot document) {
    return Container(
      margin: EdgeInsets.all(5),
      child: FlatButton(
        child: Text(
          document.data()['categoryName'],
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.blueGrey.shade600, style: BorderStyle.solid)),
        color: Colors.blueGrey.shade400,
        onPressed: () {
          Navigator.pushNamed(context, CategoryNoteDetail.routeName,
              arguments: CategoryNoteDetail.category(
                id: document.id.toString(),
                name: document.data()['categoryName'],
              ));
        },
      ),
    );
  }
}
