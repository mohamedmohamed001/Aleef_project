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

String _readString(
    Map<String, dynamic> petData,
    Map<String, dynamic> json,
    List<String> keys, {
      String defaultValue = '',
    }) {
  for (final key in keys) {
    final value = petData[key] ?? json[key];

    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString();
    }
  }

  return defaultValue;
}

int _readInt(
    Map<String, dynamic> petData,
    Map<String, dynamic> json,
    List<String> keys, {
      int defaultValue = 0,
    }) {
  for (final key in keys) {
    final value = petData[key] ?? json[key];

    if (value == null) continue;

    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();

    final parsedValue = int.tryParse(value.toString());
    if (parsedValue != null) return parsedValue;
  }

  return defaultValue;
}

List<T> _readList<T>({
  required Map<String, dynamic> petData,
  required Map<String, dynamic> json,
  required List<String> keys,
  required T Function(Map<String, dynamic>) fromJson,
}) {
  dynamic value;

  for (final key in keys) {
    value = petData[key] ?? json[key];

    if (value is List || value is Map) break;
  }

  if (value is Map) {
    return [
      fromJson(Map<String, dynamic>.from(value)),
    ];
  }

  if (value is! List) return [];

  return value
      .whereType<Map>()
      .map((item) => fromJson(Map<String, dynamic>.from(item)))
      .toList();
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

  final int visits;

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
    required this.visits,
    required this.medicalRecords,
    required this.upcomingVaccinations,
    required this.overdueVaccinations,
    required this.completedVaccinations,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> petData = json['pet'] is Map
        ? Map<String, dynamic>.from(json['pet'] as Map)
        : json;

    final String id = _readString(
      petData,
      json,
      [
        'id',
        '_id',
        'petId',
        'pet_id',
      ],
    );

    final List<MedicalRecord> medicalRecords = _readList<MedicalRecord>(
      petData: petData,
      json: json,
      keys: [
        'medicalRecords',
        'medical_records',
        'medicalRecord',
        'medical_record',
        'records',
      ],
      fromJson: MedicalRecord.fromJson,
    );

    final List<Vaccination> upcomingVaccinations = _readList<Vaccination>(
      petData: petData,
      json: json,
      keys: [
        'upcomingVaccinations',
        'upComingVaccinations',
        'upcommingVaccinations',
        'upcoming_vaccinations',
        'upcomming_vaccinations',
        'upComingVaccination',
        'upcomingVaccination',
        'upcommingVaccination',
      ],
      fromJson: Vaccination.fromJson,
    );

    final List<Vaccination> overdueVaccinations = _readList<Vaccination>(
      petData: petData,
      json: json,
      keys: [
        'overdueVaccinations',
        'overdue_vaccinations',
        'overDueVaccinations',
        'overdueVaccination',
        'overDueVaccination',
      ],
      fromJson: Vaccination.fromJson,
    );

    final List<Vaccination> completedVaccinations = _readList<Vaccination>(
      petData: petData,
      json: json,
      keys: [
        'completedVaccinations',
        'completed_vaccinations',
        'completedVaccination',
      ],
      fromJson: Vaccination.fromJson,
    );

    final int visits = _readInt(
      petData,
      json,
      [
        'visits',
        'visitCount',
        'visitsCount',
        'appointmentsCount',
        'appointmentCount',
        'appointments_count',
        'completedAppointments',
        'completedAppointmentsCount',
        'completed_appointments_count',
        'medicalRecordsCount',
        'medical_records_count',
      ],
      defaultValue: medicalRecords.length,
    );

    return PetModel(
      id: id,
      name: capitalizeEachWord(
        _readString(
          petData,
          json,
          ['name'],
        ),
      ),
      type: _readString(
        petData,
        json,
        ['type'],
      ),
      breed: _readString(
        petData,
        json,
        ['breed'],
      ),
      gender: _readString(
        petData,
        json,
        ['gender'],
      ),
      birthDate: _readString(
        petData,
        json,
        ['birthDate', 'birth_date'],
      ),
      weight: _readString(
        petData,
        json,
        ['weight'],
        defaultValue: '0',
      ),
      age: _readString(
        petData,
        json,
        ['age'],
        defaultValue: '0',
      ),
      profilePic: _readString(
        petData,
        json,
        [
          'profilePic',
          'profile_pic',
          'image',
          'imageUrl',
          'profileImage',
          'profile_image',
          'photo',
        ],
      ),
      visits: visits,
      medicalRecords: medicalRecords,
      upcomingVaccinations: upcomingVaccinations,
      overdueVaccinations: overdueVaccinations,
      completedVaccinations: completedVaccinations,
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
      id: (json['id'] ?? json['_id'] ?? json['recordId'] ?? '').toString(),
      condition: (json['condition'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      date: (json['date'] ?? json['createdAt'] ?? json['created_at'] ?? '')
          .toString(),
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
      id: (json['id'] ?? json['_id'] ?? json['vaccinationId'] ?? '').toString(),
      parentVaccineId: json['parentVaccineId']?.toString(),
      vaccineName: (json['vaccineName'] ?? json['name'] ?? '').toString(),
      type: json['type']?.toString(),
      dose: json['dose']?.toString(),
      notes: json['notes']?.toString(),
      nextDueDate:
      (json['nextDueDate'] ?? json['next_due_date'] ?? json['dueDate'])
          ?.toString(),
      vaccinatedAt:
      (json['vaccinatedAt'] ?? json['vaccinated_at'] ?? json['dateTaken'])
          ?.toString(),
    );
  }
}