import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/api/data.dart';

class CategoryDetail extends StatefulWidget {
  static const routeName = '/category_detail';
  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  final FirestoreDatabase firebaseInstance = FirestoreDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text("Category List"),
          backgroundColor: Colors.blueGrey,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firebaseInstance.streamCategoryGet(),
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

            return Container(
              margin: EdgeInsets.all(5),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5.0,
                    color: Colors.white,
                    child: ListTile(
                      leading: Icon(
                        Icons.clear_all,
                        color: Colors.black87,
                      ),
                      title: Text(
                        snapshot.data.docs[index]['categoryName'],
                        style: TextStyle(color: Colors.black87, fontSize: 20),
                      ),
                      trailing: InkWell(
                          onTap: () {
                            var categoryId = snapshot.data.docs[index].id;
                            _showDeleteDialog(context, categoryId);
                          },
                          child: Icon(Icons.delete_forever,
                              size: 28, color: Colors.grey)),
                    ),
                  );
                },
                itemCount: snapshot.data.docs.length,
              ),
            );
          },
        ));
  }

  _showDeleteDialog(BuildContext context, String categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                "Category Delete",
                style: TextStyle(fontSize: 18),
              ),
              content: Text(
                "Are you sure you want to delete the note ?",
                style: TextStyle(fontSize: 18),
              ),
              actions: [
                FlatButton(
                  textColor: Colors.red.shade900,
                  child: Text(
                    "Delete Category",
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () async {
                    await firebaseInstance.deleteCategory(categoryId);
                    Navigator.of(context).pop();

                    CollectionReference notes = firebaseInstance.collectionNote;

                    return notes
                        .where('categoryId', isEqualTo: categoryId)
                        .get()
                        .then((querySnapshot) {
                      WriteBatch batch = FirebaseFirestore.instance.batch();

                      querySnapshot.docs.forEach((document) {
                        batch.delete(document.reference);
                      });

                      return batch.commit();
                    });
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
                )
              ],
            ));
  }
}
