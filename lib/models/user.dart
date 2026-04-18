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

  // constructor to create user object
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

  // convert user object into map (for database insert)
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

  // convert database data into user object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      height: map['height'].toDouble(),
      weight: map['weight'].toDouble(),
      goalWeight: map['goalWeight'].toDouble(),
      targetSteps: map['targetSteps'],
      email: map['email'],
      profileImagePath: map['profileImagePath'],
    );
  }
}