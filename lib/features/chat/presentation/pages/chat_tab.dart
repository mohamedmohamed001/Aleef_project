import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Chats",
                style: AppTextStyles.titleLarge,
              ),
              SizedBox(height: 1),
              Text("Your conversations with doctors")
            ],
          ),
        ),
      ),
    );
  }
}
