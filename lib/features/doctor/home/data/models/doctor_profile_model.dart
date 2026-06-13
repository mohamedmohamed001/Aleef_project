class DoctorProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String city;
  final String specialization;
  final String about;
  final String clinicName;
  final String clinicAddress;
  final String profilePic;
  final List<ScheduleItem> schedule;

  DoctorProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.specialization,
    required this.about,
    required this.clinicName,
    required this.clinicAddress,
    required this.profilePic,
    required this.schedule,
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    // التعامل مع الـ wrapper الخاص بـ "doctor" الذي يأتي في الـ API
    final data = json['doctor'] ?? json; 
    
    return DoctorProfileModel(
      id: data['_id'] ?? data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      city: data['city'] ?? '',
      specialization: data['specialization'] ?? '',
      about: data['about'] ?? 'No bio available.',
      clinicName: data['clinicName'] ?? data['clinic']?['name'] ?? '',
      clinicAddress: data['clinicAddress'] ?? data['clinic']?['address'] ?? '',
      profilePic: data['profilePic'] ?? '',
      schedule: data['schedule'] != null
          ? List<ScheduleItem>.from(
              data['schedule'].map((x) => ScheduleItem.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'city': city,
      'specialization': specialization,
      'about': about,
      'clinicName': clinicName,
      'address': clinicAddress,
      'profilePic': profilePic,
      'schedule': schedule.map((x) => x.toJson()).toList(),
    };
  }
}

class ScheduleItem {
  final String? id;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final bool isAvailable;

  ScheduleItem({
    this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      id: json['id'] ?? json['_id'],
      dayOfWeek: json['day_of_week'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      isAvailable: json['is_available'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id, // إضافة الـ id في الإرسال
      'day_of_week': dayOfWeek,
      'start_time': startTime,
      'end_time': endTime,
      'is_available': isAvailable,
    };
  }
}