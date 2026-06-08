class DoctorModel {
  final String? id;
  final String? name;
  final String? specialization;
  final String? rating;
  final int? reviewsCount;
  final String? location;
  final String? phone;
  final String? city;
  final String? address;
  final String? profilePic;
  final double? ratingsCount;
  final String? about;
  final int? appointmentFee;

  DoctorModel({
    this.id,
    this.name,
    this.specialization,
    this.rating,
    this.reviewsCount,
    this.location,
    this.phone,
    this.city,
    this.address,
    this.profilePic,
    this.ratingsCount,
    this.about,
    this.appointmentFee,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'location': location,
      'phone': phone,
      'city': city,
      'address': address,
      'profilePic': profilePic,
      'ratingsCount': ratingsCount,
      'about': about,
      'appointmentFee': appointmentFee,
    };
  }

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      specialization: json['specialization']?.toString(),
      rating: json['rating']?.toString(),
      reviewsCount: (json['ratingCount'] as num?)?.toInt(),
      location: json['location']?.toString(),
      phone: json['phone']?.toString(),
      city: json['city']?.toString(),
      address: json['address']?.toString(),
      profilePic: json['profilePic']?.toString(),
      ratingsCount: (json['ratingsCount'] as num?)?.toDouble(),
      about: json['about']?.toString(),
      appointmentFee: (json['appointmentFee'] as num?)?.toInt(),
    );
  }
}