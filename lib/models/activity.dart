class Activity {
  int? id;
  String title;
  String type;
  int duration;
  double calories;
  int steps;
  double distance;
  String activityDate;
  String location;
  String notes;

  Activity({
    this.id,
    required this.title,
    required this.type,
    required this.duration,
    required this.calories,
    required this.steps,
    required this.distance,
    required this.activityDate,
    required this.location,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'duration': duration,
      'calories': calories,
      'steps': steps,
      'distance': distance,
      'activityDate': activityDate,
      'location': location,
      'notes': notes,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      title: map['title'] ?? '',
      type: map['type'] ?? '',
      duration: map['duration'] ?? 0,
      calories: (map['calories'] ?? 0).toDouble(),
      steps: map['steps'] ?? 0,
      distance: (map['distance'] ?? 0).toDouble(),
      activityDate: map['activityDate'] ?? '',
      location: map['location'] ?? '',
      notes: map['notes'] ?? '',
    );
  }
}