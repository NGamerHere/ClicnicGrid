
class Patient {
  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
  });

  final int id;
  final String name;
  final int age;
  final String gender;
  final List<Session> sessions = [];

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: "${json['firstName']} ${json['lastName']}",
      age: _calculateAge(json['dateOfBirth']),
      gender: json['gender'],
    );
  }

  static int _calculateAge(String dob) {
    final birth = DateTime.parse(dob);
    final today = DateTime.now();
    int age = today.year - birth.year;
    if (today.month < birth.month || (today.month == birth.month && today.day < birth.day)) {
      age--;
    }
    return age;
  }
}
class Session {
  Session({required this.date, required this.purpose, required this.notes});
  final DateTime date;
  final String purpose;
  final String notes;
}