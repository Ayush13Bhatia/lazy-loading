class PersonModel {
  final int? id;
  final String? name;
  final int? age;
  PersonModel({
    this.id,
    this.name,
    this.age,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  factory PersonModel.fromJson(Map<String, dynamic> json) => PersonModel(
        id: json["id"],
        name: json["name"],
        age: json["age"],
      );
}
