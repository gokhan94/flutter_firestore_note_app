import 'package:flutter/material.dart';

class CategoryNoteDetail extends StatelessWidget {
  static const routeName = '/category-detail';

  String id;
  String name;
  CategoryNoteDetail();

  CategoryNoteDetail.category({this.id, this.name});

  @override
  Widget build(BuildContext context) {
    final CategoryNoteDetail categoryData = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("${categoryData.name} Categories"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [Text(categoryData.id)],
        ),
      ),
    );
  }
}
