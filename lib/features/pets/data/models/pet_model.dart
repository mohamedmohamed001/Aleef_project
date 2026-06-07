String capitalizeEachWord(String text) {
  final trimmedText = text.trim();

  if (trimmedText.isEmpty) return trimmedText;

  return trimmedText
      .split(RegExp(r'\s+'))
      .map((word) {
    if (word.isEmpty) return word;

    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  })
      .join(' ');
}

class PetModel {
  final String id;
  final String name;
  final String type;
  final String breed;
  final String gender;
  final String birthDate;
  String weight;
  String age;
  String profilePic;
  final List<MedicalRecord> medicalRecords;
  final List<Vaccination> upcomingVaccinations;
  final List<Vaccination> overdueVaccinations;
  final List<Vaccination> completedVaccinations;

  PetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.gender,
    required this.birthDate,
    required this.weight,
    required this.age,
    required this.profilePic,
    required this.medicalRecords,
    required this.upcomingVaccinations,
    required this.overdueVaccinations,
    required this.completedVaccinations,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> petData = json['pet'] != null
        ? json['pet'] as Map<String, dynamic>
        : json;

    return PetModel(
      id: petData['_id'] ?? petData['id'] ?? json['_id'] ?? json['id'] ?? '',
      name: capitalizeEachWord(
        (petData['name'] ?? json['name'] ?? '').toString(),
      ),
      type: petData['type'] ?? json['type'] ?? '',
      breed: petData['breed'] ?? json['breed'] ?? '',
      gender: petData['gender'] ?? json['gender'] ?? '',
      birthDate: petData['birthDate'] ?? json['birthDate'] ?? '',
      weight: (petData['weight'] ?? json['weight'] ?? '0').toString(),
      age: (petData['age'] ?? json['age'] ?? '0').toString(),
      profilePic: petData['profilePic'] ?? json['profilePic'] ?? '',
      medicalRecords:
      (petData['medicalRecords'] as List? ?? json['medicalRecords'] as List?)
          ?.map((item) => MedicalRecord.fromJson(item))
          .toList() ??
          [],
      upcomingVaccinations:
      (petData['upcommingVaccinations'] as List? ??
          json['upcommingVaccinations'] as List?)
          ?.map((item) => Vaccination.fromJson(item))
          .toList() ??
          [],
      overdueVaccinations:
      (petData['overdueVaccinations'] as List? ??
          json['overdueVaccinations'] as List?)
          ?.map((item) => Vaccination.fromJson(item))
          .toList() ??
          [],
      completedVaccinations:
      (petData['completedVaccinations'] as List? ??
          json['completedVaccinations'] as List?)
          ?.map((item) => Vaccination.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class MedicalRecord {
  final String id;
  final String condition;
  final String title;
  final String description;
  final String date;

  MedicalRecord({
    required this.id,
    required this.condition,
    required this.title,
    required this.description,
    required this.date,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['_id'] ?? '',
      condition: json['condition'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? json['createdAt'] ?? '',
    );
  }
}

class Vaccination {
  final String id;
  final String? parentVaccineId;
  final String vaccineName;
  final String? type;
  final String? dose;
  final String? notes;
  final String? nextDueDate;
  final String? vaccinatedAt;

  Vaccination({
    required this.id,
    this.parentVaccineId,
    required this.vaccineName,
    this.type,
    this.dose,
    this.notes,
    this.nextDueDate,
    this.vaccinatedAt,
  });

  factory Vaccination.fromJson(Map<String, dynamic> json) {
    return Vaccination(
      id: json['_id'] ?? '',
      parentVaccineId: json['parentVaccineId'] ?? '',
      vaccineName: json['vaccineName'] ?? '',
      type: json['type'],
      dose: json['dose'],
      notes: json['notes'],
      nextDueDate: json['nextDueDate'],
      vaccinatedAt: json['vaccinatedAt'],
    );
  }
}