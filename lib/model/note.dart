class Note {
  String id;
  String name;
  String description;
  String categoryId;
  String categoryName;
  String date;

  Note(this.id, this.name, this.description, this.categoryId, this.categoryName, this.date);

  Note.withInfo({this.id, this.name, this.description, this.categoryId, this.categoryName, this.date});

  Note.fromJson(Map<String, dynamic> note) {
    id = note['id'];
    name = note["name"];
    description = note["description"];
    categoryId = note["categoryId"];
    categoryName = note["categoryName"];
    date = note["date"];
  }

  Map<String, dynamic> NotetoJson() {
    return {"id": id, "name": name, "description": description, "categoryId": categoryId, "categoryName": categoryName, "date": date};
  }


}
