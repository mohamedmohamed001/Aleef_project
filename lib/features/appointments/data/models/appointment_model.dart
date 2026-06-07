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
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['_id'],
      pet: json['pet'] != null ? PetModel.fromJson(json['pet']) : null,
      owner: json['owner']?.toString(),
      doctor: json['doctor'] != null
          ? DoctorModel.fromJson(json['doctor'])
          : null,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      time: json['time']?.toString(),
      reason: json['reason']?.toString(),
      status: json['status']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      notes: json['notes']?.toString(),
      chatId: json['chatId']?.toString(),
    );
  }
}