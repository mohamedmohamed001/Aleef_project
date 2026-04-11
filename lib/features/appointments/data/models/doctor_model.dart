class DoctorModel {
  final String name;
  final String specialty;
  final double rating;
  final int reviewsCount;
  final String location;
  final String image;

  DoctorModel({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewsCount,
    required this.location,
    required this.image,
  });
}