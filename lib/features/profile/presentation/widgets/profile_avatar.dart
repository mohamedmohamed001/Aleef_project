import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String image;

  const ProfileAvatar({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(image),
      ),
    );
  }
}