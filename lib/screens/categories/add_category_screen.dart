import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:monegement/models/category_model.dart';
import 'package:monegement/services/category_services.dart';
import 'package:monegement/widgets/curved_container.dart';
import 'package:monegement/widgets/custom_appbar.dart';
import 'package:monegement/widgets/custom_text_field.dart';
import 'package:monegement/widgets/form_row.dart';
import 'package:monegement/widgets/toast.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  TextEditingController _budgetController;
  Color currentColor;

  @override
  void initState() {
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _budgetController = TextEditingController();

    super.initState();
  }

  void handleSubmit() {
    if (_nameController.value.text.isNotEmpty &&
        _descriptionController.value.text.isNotEmpty &&
        currentColor != null) {
      // default budget is 1000
      Category newCategory = Category(
          categoryName: _nameController.value.text,
          categoryDescription: _descriptionController.value.text,
          budget: _budgetController.value.text.isNotEmpty
              ? double.parse(_budgetController.value.text)
              : 1000,
          categoryColor: currentColor.value);
      addNewCategory(context, newCategory);
    } else {
      showToast("Please fill all the details");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Category",
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: CurvedContainer(
            childWidget: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FormRow(
                  icon: Icon(Icons.category),
                  formWidget: CustomTextField(
                    inputType: TextInputType.text,
                    textEditingController: _nameController,
                    hintText: "Category name",
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                FormRow(
                  icon: Icon(Icons.account_balance_wallet),
                  formWidget: CustomTextField(
                    textEditingController: _budgetController,
                    inputType: TextInputType.number,
                    hintText: "Budget per month",
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                FormRow(
                  icon: Icon(Icons.description),
                  formWidget: CustomTextField(
                    inputType: TextInputType.text,
                    textEditingController: _descriptionController,
                    hintText: "Description for the category",
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                FormRow(
                  icon: Icon(Icons.color_lens),
                  formWidget: GestureDetector(
                    onTap: () {
                      pickColor(context);
                    },
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: currentColor == null
                          ? Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Pick a color",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                    ),
                              ),
                            )
                          : Container(
                              alignment: Alignment.bottomLeft,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentColor,
                              ),
                              height: 40,
                              width: 50,
                              child: Container(),
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                  ),
                  onPressed: handleSubmit,
                  child: Text(
                    "Add Category",
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickColor(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor:
                    currentColor == null ? Colors.limeAccent : currentColor,
                onColorChanged: (col) {
                  setState(() {
                    currentColor = col;
                  });
                },
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Select"))
            ],
          );
        });
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _descriptionController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
