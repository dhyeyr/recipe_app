class Recipe_Model {
  int? id;
  String? name;
  String? description;
  String? image;

  Recipe_Model({
    this.id,
    this.name,
    this.description,
    this.image,
  });

  factory Recipe_Model.fromJson(Map<String, dynamic> json) => Recipe_Model(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "image": image,
  };
}
