import 'package:hive/hive.dart';
part 'category_model.g.dart';

@HiveType(typeId: 1)
class Category {
  @HiveField(0)
  String categoryName;

  @HiveField(1)
  String categoryDescription;

  @HiveField(2)
  double budget;

  @HiveField(3)
  int categoryColor;

  Category(
      {this.categoryName,
      this.categoryDescription,
      this.budget,
      this.categoryColor});
}
