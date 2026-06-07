class DoctorModel {
  final String? id;
  final String? name;
  final String? specialization;
  final double? rating;
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
    this.id,
    this.about, this.appointmentFee,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      name: json['name'],
      specialization: json['specialization'],
      rating: (json['rating'] as num?)?.toDouble(),
      reviewsCount: json['reviewsCount'] as int?,
      location: json['location'],
      phone: json['phone'],
      city: json['city'],
      address: json['address'],
      profilePic: json['profilePic'],
      ratingsCount: (json['ratingsCount'] as num?)?.toDouble(),
      id: json['id'],
      about: json['about'],
      appointmentFee: json['appointmentFee'],
    );
  }
}
