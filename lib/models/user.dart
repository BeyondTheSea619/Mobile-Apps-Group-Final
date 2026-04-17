class User {
  int? id;
  String name;
  int age;
  String gender;
  double height;
  double weight;
  double goalWeight;
  int targetSteps;
  String email;
  String profileImagePath;

  User({
    this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.goalWeight,
    required this.targetSteps,
    required this.email,
    required this.profileImagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'goalWeight': goalWeight,
      'targetSteps': targetSteps,
      'email': email,
      'profileImagePath': profileImagePath,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      height: (map['height'] ?? 0).toDouble(),
      weight: (map['weight'] ?? 0).toDouble(),
      goalWeight: (map['goalWeight'] ?? 0).toDouble(),
      targetSteps: map['targetSteps'] ?? 0,
      email: map['email'] ?? '',
      profileImagePath: map['profileImagePath'] ?? '',
    );
  }
}