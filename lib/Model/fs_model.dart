import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add_recipe_model.dart';

class FsModel {
  static final _instance = FsModel._();

  FsModel._();

  factory FsModel() {
    return _instance;
  }

  void addRecipe(Recipe_Model recipe_model) async {
    await FirebaseFirestore.instance.collection("Favorite").doc().set({
      "name": recipe_model.name,
      "description": recipe_model.description,
      "image": recipe_model.image
    });
  }
}
