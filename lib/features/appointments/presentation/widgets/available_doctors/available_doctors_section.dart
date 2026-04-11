import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/doctor_model.dart';
import 'doctor_card.dart';
import 'doctor_search_field.dart';

class AvailableDoctorsSection extends StatefulWidget {
  const AvailableDoctorsSection({super.key});

  @override
  State<AvailableDoctorsSection> createState() =>
      _AvailableDoctorsSectionState();
}

class _AvailableDoctorsSectionState extends State<AvailableDoctorsSection> {
  final List<DoctorModel> doctors = [
    DoctorModel(
      name: "Dr. Amira Hassan",
      specialty: "General Veterinarian",
      rating: 4.9,
      reviewsCount: 128,
      location: "Cairo",
      image: "assets/images/doctor.png",
    ),
    DoctorModel(
      name: "Dr. Ahmed Ali",
      specialty: "Surgery Specialist",
      rating: 4.7,
      reviewsCount: 98,
      location: "Giza",
      image: "assets/images/doctor.png",
    ),
  ];

  List<DoctorModel> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    filteredDoctors = doctors;
  }

  void searchDoctors(String query) {
    final results = doctors.where((doctor) {
      return doctor.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredDoctors = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "Available Doctors",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: DoctorSearchField(
              onChanged: searchDoctors,
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: filteredDoctors
                  .map(
                    (doctor) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: DoctorCard(
                    doctor: doctor,
                    onTap: () {
                      // TODO: navigate to schedule
                    },
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}