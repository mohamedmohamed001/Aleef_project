import '../../../pets/data/models/pet_model.dart';
import 'doctor_model.dart';

class AppointmentModel {
  final String? id;
  final PetModel? pet;
  final String? owner;
  final DoctorModel? doctor;
  final DateTime? date;
  final String? time;
  final String? reason;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? notes;
  final String? chatId;
  final dynamic appointmentFee;
  final String? rejectionReason;

  AppointmentModel({
    this.id,
    this.pet,
    this.owner,
    this.doctor,
    this.date,
    this.time,
    this.reason,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.notes,
    this.chatId,
    this.appointmentFee,
    this.rejectionReason,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),

      pet: json['pet'] != null && json['pet'] is Map<String, dynamic>
          ? PetModel.fromJson(json['pet'] as Map<String, dynamic>)
          : null,

      owner: json['owner']?.toString(),

      doctor: json['doctor'] != null && json['doctor'] is Map<String, dynamic>
          ? DoctorModel.fromJson(json['doctor'] as Map<String, dynamic>)
          : null,

      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString())
          : null,

      time: json['time']?.toString(),

      reason: json['reason']?.toString(),

      status: json['status']?.toString(),

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,

      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,

      notes: json['notes']?.toString(),

      chatId: json['chatId']?.toString() ?? json['chat']?.toString(),

      appointmentFee: json['appointmentFee'] ??
          json['appointment_fee'] ??
          json['fee'],

      rejectionReason: json['rejectionReason']?.toString() ??
          json['rejectionsReason']?.toString() ??
          json['rejection_reason']?.toString(),
    );
  }
}