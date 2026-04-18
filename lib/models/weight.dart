class Weight {
  int? id;
  double weight;
  double bmi;
  String note;
  String weightDate;
  String photoPath;

  Weight({
    this.id,
    required this.weight,
    required this.bmi,
    required this.note,
    required this.weightDate,
    required this.photoPath,
  });

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

  factory Weight.fromMap(Map<String, dynamic> map) {
    return Weight(
      id: map['id'],
      weight: (map['weight'] ?? 0).toDouble(),
      bmi: (map['bmi'] ?? 0).toDouble(),
      note: map['note'] ?? '',
      weightDate: map['weightDate'] ?? '',
      photoPath: map['photoPath'] ?? '',
    );
  }
}