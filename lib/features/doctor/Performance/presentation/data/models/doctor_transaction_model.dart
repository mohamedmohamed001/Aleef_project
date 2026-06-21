enum TransactionType {
  income,
  outcome,
  pending,
}

class DoctorTransaction {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final double amount;
  final String status;
  final TransactionType type;

  const DoctorTransaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.amount,
    required this.status,
    required this.type,
  });
}