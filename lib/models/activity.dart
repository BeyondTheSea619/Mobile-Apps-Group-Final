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

  // simple constructor to create activity object
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

  // convert object to map (used when inserting into database)
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

  // convert map from database back to object
  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      title: map['title'],
      type: map['type'],
      duration: map['duration'],
      calories: map['calories'].toDouble(),
      steps: map['steps'],
      distance: map['distance'].toDouble(),
      activityDate: map['activityDate'],
      location: map['location'],
      notes: map['notes'],
    );
  }
}