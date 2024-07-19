import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/Model/add_recipe_model.dart';

class LikedRecipePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFDEEDC),
      appBar: AppBar(
          backgroundColor: Color(0xffFFD8A9), title: Text('Liked Recipes')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Favorite').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No liked recipes available'));
          } else {
            final docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                final recipe = Recipe_Model.fromJson(data);
                return Container(
                  margin: EdgeInsets.all(5),
                  color: Color(0xffFFD8A9),
                  child: Row(
                    children: [
                      Container(
                        child: recipe.image != null
                            ? Image.file(
                                File(recipe.image.toString()),
                                height: 100,
                              )
                            : null,
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(recipe.name ?? ""),
                          subtitle: Text(recipe.description ?? ""),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('Favorite')
                                  .doc(docs[index].id)
                                  .delete();
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
    );
  }
}
