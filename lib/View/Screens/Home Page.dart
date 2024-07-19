import 'package:recipe_app/Model/add_recipe_model.dart';
import 'package:recipe_app/Model/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'LikedRecipePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Controller/recipecontroller.dart';
import '../../Model/fs_model.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  final BudgetController budgetController = Get.put(BudgetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAF1E4),
      appBar: AppBar(
          backgroundColor: Color(0xffCEDEBD),
          title: Text(
            "Recipes",
            style: TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(LikedRecipePage());
                },
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ))
          ]),
      body: StreamBuilder<List<Recipe_Model>>(
        stream: DbHelper.instance.getRecipesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            List<Recipe_Model> recipes = snapshot.data!;
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                var recipe = recipes[index];
                return Container(
                  margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                  decoration: BoxDecoration(color: Color(0xffCEDEBD)),
                  child: Row(
                    children: [
                      Container(
                        child: recipe.image != null
                            ? Image.file(
                          File(recipe.image.toString()),
                          height: 120,
                        )
                            : null,
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            recipe.name??"",
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(recipe.description??"",
                              style: TextStyle(color: Colors.black)),
                          trailing: DropdownButton<String>(
                            icon: Icon(Icons.more_vert),
                            items: <String>['Delete', 'Favorite', 'Edit']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue == 'Delete') {
                                DbHelper.instance.deleteUserData(recipe.id!);
                              } else if (newValue == 'Favorite') {
                                Recipe_Model recipem = Recipe_Model(
                                  name: recipe.name,
                                  description: recipe.description,
                                  image: recipe.image,
                                );
                                FsModel().addRecipe(recipem);
                              } else if (newValue == 'Edit') {
                                _editRecipeDialog(recipe);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCustomDialog();
        },
        shape: CircleBorder(),
        child: Icon(Icons.edit),
      ),
    );
  }

  void showCustomDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white54,
        title: const Text("Add Product"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height / 1.9,
                width: MediaQuery.sizeOf(context).width / 1.2,
                child: Form(
                  key: budgetController.globalKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                            () => CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.black12,
                          backgroundImage: budgetController.filepath.isNotEmpty
                              ? FileImage(File(budgetController.filepath.value))
                              : null,
                          child: budgetController.filepath.isEmpty
                              ? IconButton(
                            onPressed: () {
                              budgetController.pickImage(true);
                            },
                            icon: Icon(
                              Icons.camera_alt_rounded,
                            ),
                          )
                              : SizedBox.shrink(),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          budgetController.pickImage(false);
                        },
                        icon: Icon(Icons.photo),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          controller: budgetController.name,
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return "Plz Enter Name";
                            } else {
                              return null;
                            }
                          },
                          style: TextStyle(color: Colors.black54),
                          decoration: InputDecoration(
                            labelText: "Enter Recipe Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value?.isEmpty ?? false) {
                              return "Plz Enter Your Income or Expense";
                            } else {
                              return null;
                            }
                          },
                          controller: budgetController.description,
                          style: TextStyle(color: Colors.black54),
                          decoration: InputDecoration(
                            labelText: "Description",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Colors.white30)),
                        onPressed: () {
                          budgetController.fillData();
                        },
                        child: Text(
                          "Add Recipe",
                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible:
      true, // Set to false if you don't want to dismiss the dialog by tapping outside of it
    );
  }

  void _editRecipeDialog(Recipe_Model recipe) {
    final TextEditingController nameController = TextEditingController(text: recipe.name);
    final TextEditingController descriptionController = TextEditingController(text: recipe.description);
    final BudgetController budgetController = Get.find<BudgetController>();

    budgetController.filepath.value = recipe.image ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Recipe'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                      () => CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.black12,
                    backgroundImage: budgetController.filepath.isNotEmpty
                        ? FileImage(File(budgetController.filepath.value))
                        : null,
                    child: budgetController.filepath.isEmpty
                        ? IconButton(
                      onPressed: () {
                        budgetController.pickImage(true);
                      },
                      icon: Icon(Icons.camera_alt_rounded),
                    )
                        : SizedBox.shrink(),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    budgetController.pickImage(false);
                  },
                  icon: Icon(Icons.photo),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                recipe.name = nameController.text;
                recipe.description = descriptionController.text;
                recipe.image = budgetController.filepath.value;
                await DbHelper.instance.updateRecipe(recipe);
                budgetController.filepath.value = ''; // Clear the image path
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
