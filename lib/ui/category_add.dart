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
      appBar: AppBar(
        title: Text("Category Add"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: 'Category Add',
                    suffixIcon: Icon(
                      Icons.check_circle,
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a name';
                    }
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
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: RaisedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {

                  _formKey.currentState.save();

                  Category category = Category();
                  category.categoryName = _categoryName;

                 await collectionCatergory.addCategory(category).then((value){
                   // DocumentReference(categories/DVVGnMtE3DP6awNKvFN6)
                 });
                } else {
                  print('Error');
                }
              },
              child: Text('Create'),
            ),
          )
        ],
      ),
    );
  }
}
