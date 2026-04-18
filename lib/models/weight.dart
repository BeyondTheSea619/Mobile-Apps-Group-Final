class Weight {
  int? id;

  double weight;
  double bmi;

  String note;
  String weightDate;
  String photoPath;

  // constructor to create weight entry
  Weight({
    this.id,
    required this.weight,
    required this.bmi,
    required this.note,
    required this.weightDate,
    required this.photoPath,
  });

  // convert object to map (used when saving to database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weight': weight,
      'bmi': bmi,
      'note': note,
      'weightDate': weightDate,
      'photoPath': photoPath,
    };
  }

  // convert database map back to object
  factory Weight.fromMap(Map<String, dynamic> map) {
    return Weight(
      id: map['id'],
      weight: map['weight'].toDouble(),
      bmi: map['bmi'].toDouble(),
      note: map['note'],
      weightDate: map['weightDate'],
      photoPath: map['photoPath'],
    );
  }
}