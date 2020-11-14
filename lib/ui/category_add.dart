import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/api/data.dart';
import 'package:flutter_note_app/model/category.dart';

class CategoryAdd extends StatefulWidget {
  static const routeName = '/category_add';

  @override
  _CategoryAddState createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {

  final _formKey = GlobalKey<FormState>();
  final FirestoreDatabase collectionCatergory = FirestoreDatabase();
  String _categoryName = '';


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text("Category Add"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white70, fontSize: 20.0),
                    fillColor: Colors.grey.shade500,
                    filled: true,
                    labelText: 'Category Add',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color:  Colors.white70
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.white70,
                        width: 1.0,
                      )),
                    suffixIcon: Icon(
                      Icons.category,
                      color: Colors.white70,
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value){
                    setState(() {
                      _categoryName = value;
                    });
                  },
                ),
              ),

          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: RaisedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {

                  _formKey.currentState.save();

                  Category category = Category();
                  category.categoryName = _categoryName;

                 await collectionCatergory.addCategory(category).then((value){
                   Navigator.pop(context);
                 });
                } else {
                  print('Error');
                }
              },
              color: Colors.blueGrey.shade600,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(color: Colors.blueGrey.shade600)
              ),
              child: Text('Create Category', style: TextStyle(fontSize: 18, color: Colors.white),),

            ),
          )
        ],
      ),
    );
  }
}
