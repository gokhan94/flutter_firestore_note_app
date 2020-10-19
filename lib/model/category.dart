class Category {
  int categoryId;
  String categoryName;

  Category({this.categoryName, this.categoryId});

  Category.fromJson(Map<String, dynamic> category) {
    //categoryId = category["categoryId"];
    categoryName = category["categoryName"];
  }

  Map<String, dynamic> CategorytoJson() {
    return {"categoryName": categoryName};
  }
}
