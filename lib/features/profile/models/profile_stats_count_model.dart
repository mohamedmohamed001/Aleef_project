class ProfileStatsCountModel {
  final int appointments;
  final int orders;

  const ProfileStatsCountModel({
    required this.appointments,
    required this.orders,
  });

  factory ProfileStatsCountModel.fromJson(Map<String, dynamic> json) {
    final count = json['count'] as Map<String, dynamic>? ?? {};

    return ProfileStatsCountModel(
      appointments: int.tryParse(count['appointments']?.toString() ?? '0') ?? 0,
      orders: int.tryParse(count['orders']?.toString() ?? '0') ?? 0,
    );
  }
}