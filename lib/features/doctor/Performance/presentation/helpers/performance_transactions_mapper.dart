import '../data/models/doctor_performance_model.dart';
import '../data/models/doctor_transaction_model.dart';
import 'performance_ui_helpers.dart';

List<DoctorTransaction> buildTransactionsFromAppointments(
    List<DoctorPerformanceAppointmentModel> appointments,
    ) {
  return appointments.map((appointment) {
    final status = appointment.status.toLowerCase();

    final isCompleted = status == 'completed';
    final isCancelled = status == 'cancelled';

    return DoctorTransaction(
      id: appointment.id,
      title: isCompleted
          ? 'Appointment payment'
          : isCancelled
          ? 'Cancellation deduction'
          : 'Pending appointment',
      subtitle:
      '${capitalize(appointment.pet.type)} with ${capitalize(appointment.owner.name)}',
      time: appointment.time,
      amount: isCompleted
          ? 250
          : isCancelled
          ? -50
          : 0,
      status: appointment.status,
      type: isCompleted
          ? TransactionType.income
          : isCancelled
          ? TransactionType.outcome
          : TransactionType.pending,
    );
  }).toList();
}