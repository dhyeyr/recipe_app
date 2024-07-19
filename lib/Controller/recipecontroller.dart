// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../Model/add_recipe_model.dart';
// import '../Model/db_helper.dart';
//
// class BudgetController extends GetxController {
//   TextEditingController name = TextEditingController();
//   GlobalKey<FormState> globalKey = GlobalKey<FormState>();
//
//   TextEditingController description = TextEditingController();
//
//   RxList<Recipe_Model> inList = <Recipe_Model>[].obs;
//   RxList<Recipe_Model> exList = <Recipe_Model>[].obs;
//
//   RxString filepath = "".obs;
//
//   void pickImage(bool isCamara) async {
//     XFile? file = await ImagePicker()
//         .pickImage(source: isCamara ? ImageSource.camera : ImageSource.gallery);
//     filepath.value = file!.path;
//   }
//
//   void fillData() async {
//     DbHelper helper = DbHelper();
//     if (globalKey.currentState?.validate() ?? false) {
//       await helper.insertRecipe(
//         Recipe_Model(
//           name: name.text,
//           description: description.text,
//           image: filepath.toString(),
//         ),
//       );
//       // Get.off(() => AddExpense());
//       name.clear();
//       description.clear();
//       filepath.value="";
//       print("success");
//     } else {
//       print(" else success");
//     }
//   }
// }
//
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';

import '../Model/add_recipe_model.dart';
import '../Model/db_helper.dart';

class BudgetController extends GetxController {
  var filepath = ''.obs;
  final globalKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final description = TextEditingController();

  Future<void> pickImage(bool fromCamera) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: fromCamera ? ImageSource.camera : ImageSource.gallery);
    if (pickedFile != null) {
      filepath.value = pickedFile.path;
    }
  }

  void fillData() async {
    if (globalKey.currentState!.validate()) {
      // Save the recipe to the database
      final recipe = Recipe_Model(
        name: name.text,
        description: description.text,
        image: filepath.value,
      );
      await DbHelper.instance.insertRecipe(recipe);
      filepath.value = ''; // Clear the image path
      name.clear();
      description.clear();
      Get.back(); // Close the dialog
    }
  }
}
