class UserModel {
  int name;
  String gender;
  String age;
  int address;
  String picture;

  UserModel({
    required this.name,
    required this.gender,
    required this.age,
    required this.address,
    required this.picture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json["name"] ?? "",
    gender: json["gender"] ?? "",
    age: json["age"] ?? "",
    address: json["address"] ?? "",
    picture: json["picture"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "gender": gender,
    "age": age,
    "address": address,
    "picture": picture,
  };
}
