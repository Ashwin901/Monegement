import 'package:flutter/cupertino.dart';
import 'package:monegement/models/category_model.dart';

List<Category> defaultCategories = [
  Category(
      categoryName: "Food",
      categoryColor: Color(0xff1eae98).value,
      budget: 2500.0,
      categoryDescription: "Money spent on food items"),
  Category(
      categoryName: "Bills",
      categoryColor: Color(0xfff21170).value,
      budget: 3000.0,
      categoryDescription: "Bill payments"),
  Category(
      categoryName: "Other",
      categoryColor: Color(0xffff7b54).value,
      budget: 1000.0,
      categoryDescription: "Miscellaneous expenses"),
];
