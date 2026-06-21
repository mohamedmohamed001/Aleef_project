import 'dart:io';

class EndAppointmentRequestModel {
  final MedicalRecordModel medicalRecord;
  final VaccinationModel? vaccination;
  final UpComingVaccinationModel? upComingVaccination;
  final List<File>? attachments;
  final int chatExpiryDays;

  EndAppointmentRequestModel({
    required this.medicalRecord,
    required this.chatExpiryDays,
    this.vaccination,
    this.upComingVaccination,
    this.attachments,
  });

  Map<String, dynamic> toFormDataMap() {
    final Map<String, dynamic> data = {
      'medicalRecord[title]': medicalRecord.title,
      'medicalRecord[condition]': medicalRecord.condition,
      'medicalRecord[description]': medicalRecord.description,
      'chatExpiryDays': chatExpiryDays,
    };

    if (vaccination != null) {
      data.addAll({
        'vaccination[vaccineName]': vaccination!.vaccineName,
        'vaccination[dose]': vaccination!.dose,
        'vaccination[notes]': vaccination!.notes,
      });
    }

    if (upComingVaccination != null) {
      data.addAll({
        // خلي بالك: الاسم ده لازم يبقى زي الباك إند بالظبط
        'upCommingVaccination[vaccineName]':
        upComingVaccination!.vaccineName,
        'upCommingVaccination[nextDueDate]':
        upComingVaccination!.nextDueDate,
      });
    }

    return data;
  }
}

class MedicalRecordModel {
  final String title;
  final String condition;
  final String description;

  MedicalRecordModel({
    required this.title,
    required this.condition,
    required this.description,
  });
}

class VaccinationModel {
  final String vaccineName;
  final String dose;
  final String notes;

  VaccinationModel({
    required this.vaccineName,
    required this.dose,
    required this.notes,
  });
}

class UpComingVaccinationModel {
  final String vaccineName;
  final String nextDueDate;

  UpComingVaccinationModel({
    required this.vaccineName,
    required this.nextDueDate,
  });
}