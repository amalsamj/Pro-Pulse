class PatientModel {
  final String patientId;
  final String name;
  final int age;
  final String aadhaar;
  final String gender;
  final String bloodGroup;
  final String city;
  final String history;
  final String medicines;
  final String imagePath;

  PatientModel({
    required this.patientId,
    required this.name,
    required this.age,
    required this.aadhaar,
    required this.gender,
    required this.bloodGroup,
    required this.city,
    required this.history,
    required this.medicines,
    required this.imagePath,
  });

  PatientModel copyWith({
    String? patientId,
    String? name,
    int? age,
    String? aadhaar,
    String? gender,
    String? bloodGroup,
    String? city,
    String? history,
    String? medicines,
    String? imagePath,
  }) {
    return PatientModel(
      patientId: patientId ?? this.patientId,
      name: name ?? this.name,
      age: age ?? this.age,
      aadhaar: aadhaar ?? this.aadhaar,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      city: city ?? this.city,
      history: history ?? this.history,
      medicines: medicines ?? this.medicines,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

