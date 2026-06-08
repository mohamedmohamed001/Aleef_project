class AppointmentRequestsResponse {
  final String status;
  final List<AppointmentRequestModel> appointments;
  final int results;
  final int page;
  final int totalPages;
  final int totalRequests;

  const AppointmentRequestsResponse({
    required this.status,
    required this.appointments,
    required this.results,
    required this.page,
    required this.totalPages,
    required this.totalRequests,
  });

  factory AppointmentRequestsResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentRequestsResponse(
      status: json['status']?.toString() ?? '',
      appointments: (json['appointments'] as List<dynamic>? ?? [])
          .map(
            (appointment) => AppointmentRequestModel.fromJson(
          appointment as Map<String, dynamic>,
        ),
      )
          .toList(),
      results: _parseInt(json['results']),
      page: _parseInt(json['page']),
      totalPages: _parseInt(json['totalPages']),
      totalRequests: _parseInt(json['totalRequests']),
    );
  }
}

class AppointmentRequestModel {
  final String id;
  final DateTime? date;
  final String time;
  final String reason;
  final String status;
  final String? notes;
  final DateTime? createdAt;
  final AppointmentPetModel pet;
  final AppointmentOwnerModel owner;
  final int totalCount;

  const AppointmentRequestModel({
    required this.id,
    required this.date,
    required this.time,
    required this.reason,
    required this.status,
    required this.notes,
    required this.createdAt,
    required this.pet,
    required this.owner,
    required this.totalCount,
  });

  factory AppointmentRequestModel.fromJson(Map<String, dynamic> json) {
    return AppointmentRequestModel(
      id: json['id']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? ''),
      time: json['time']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      notes: json['notes']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      pet: AppointmentPetModel.fromJson(
        json['pet'] as Map<String, dynamic>? ?? {},
      ),
      owner: AppointmentOwnerModel.fromJson(
        json['owner'] as Map<String, dynamic>? ?? {},
      ),
      totalCount: _parseInt(json['total_count']),
    );
  }
}

class AppointmentPetModel {
  final String id;
  final String name;
  final String type;
  final String gender;
  final String? profilePic;

  const AppointmentPetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.gender,
    required this.profilePic,
  });

  factory AppointmentPetModel.fromJson(Map<String, dynamic> json) {
    return AppointmentPetModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      profilePic: json['profilePic']?.toString(),
    );
  }
}

class AppointmentOwnerModel {
  final String id;
  final String name;

  const AppointmentOwnerModel({
    required this.id,
    required this.name,
  });

  factory AppointmentOwnerModel.fromJson(Map<String, dynamic> json) {
    return AppointmentOwnerModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

int _parseInt(dynamic value) {
  if (value is int) return value;

  return int.tryParse(value?.toString() ?? '') ?? 0;
}