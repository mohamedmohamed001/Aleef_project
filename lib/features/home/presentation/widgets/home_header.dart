import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../auth/presentation/widgets/custom_text_form.dart';
import 'notification_button.dart';

class HomeHeader extends StatelessWidget {
  final String? userName;
  final String? profilePic;
  final TextEditingController searchController;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.profilePic,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final firstName = (userName != null && userName!.trim().isNotEmpty)
        ? userName!.trim().split(' ').first
        : 'Guest';

    final ImageProvider profileImage =
    (profilePic != null && profilePic!.trim().isNotEmpty)
        ? NetworkImage(profilePic!)
        : const AssetImage(AppAssets.profilePhoto);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          /// decorative circles
          Positioned(
            top: -35,
            right: -25,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: -30,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1.2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white.withOpacity(0.18),
                      backgroundImage: profileImage,
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, $firstName 👋",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "How is your pet today?",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.82),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),
                  const NotificationButton(),
                ],
              ),

              const SizedBox(height: 18),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: CustomTextFormField(
                  borderRadius: BorderRadius.circular(24),
                  iconPrefix: Icons.search,
                  controller: searchController,
                  hintText: 'Search services, doctors, products...',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}