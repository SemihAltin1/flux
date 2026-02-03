final class CategoryModel {
  final int? id;
  final String? name;

  const CategoryModel({
    this.id,
    this.name,
  });

  static List<CategoryModel> categories = const [
    CategoryModel(id: 1, name: "Work"),
    CategoryModel(id: 2, name: "Personal"),
    CategoryModel(id: 3, name: "Ideas"),
    CategoryModel(id: 4, name: "Shopping"),
    CategoryModel(id: 5, name: "Education"),
  ];

}