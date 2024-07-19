
import 'package:sqflite/sqflite.dart';
import 'add_recipe_model.dart';
import 'dart:async';

class DbHelper {
  static final DbHelper _obj = DbHelper._();
  DbHelper._();

  factory DbHelper() {
    return _obj;
  }

  static DbHelper get instance => _obj;

  final String dbname = "Recipe.db";
  final String recipeTable = "Recipe";
  Database? _database;

  final _recipeStreamController = StreamController<List<Recipe_Model>>.broadcast();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDb();
    _loadRecipes();
    return _database!;
  }

  Future<Database> initDb() async {
    return await openDatabase(dbname, version: 3, onCreate: (db, version) {
      db.execute('''
      CREATE TABLE "$recipeTable" (
        "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "name" TEXT NOT NULL,
        "description" TEXT NOT NULL,
        "image" BLOB
      )
      ''');
    });
  }

  void _loadRecipes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(recipeTable);
    final recipes = List.generate(maps.length, (i) {
      return Recipe_Model.fromJson(maps[i]);
    });
    _recipeStreamController.add(recipes);
  }

  Stream<List<Recipe_Model>> getRecipesStream() {
    return _recipeStreamController.stream;
  }

  Future<void> insertRecipe(Recipe_Model recipe) async {
    final db = await database;
    await db.insert(recipeTable, recipe.toJson());
    _loadRecipes();
  }

  Future<void> updateRecipe(Recipe_Model recipe) async {
    await DbHelper.instance.updateRecipe(recipe);
    _loadRecipes();
  }

  Future<void> deleteUserData(int id) async {
    final db = await database;
    await db.delete(recipeTable, where: "id=?", whereArgs: [id]);
    _loadRecipes();
  }
}
