import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff369e97),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Find your",
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
                Text(
                  "Furry",
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
                Text(
                  "Favourite",
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    Image.asset(
                      "assets/images/paw2.png",
                      height: 130.h,
                      width: 80.w,
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// الكارد الأبيض تحت
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 30, left: 16, right: 12),
                height: 300,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Find your perfect pet\ncompanion",
                      style: AppTextStyles.titleLarge.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// زرار السحب
                    const SwipeToStartButton(),
                  ],
                ),
              ),
            ],
          ),

          /// صورة القط
          Positioned(
            top: 220,
            right: 10,
            child: Image.asset(
              "assets/images/cat_3d.png",
              width: 370,
              height: 370,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// Swipe Button
////////////////////////////////////////////////////////

class SwipeToStartButton extends StatefulWidget {
  final VoidCallback? onComplete;

  const SwipeToStartButton({super.key, this.onComplete});

  @override
  State<SwipeToStartButton> createState() => _SwipeToStartButtonState();
}

class _SwipeToStartButtonState extends State<SwipeToStartButton> {
  double dragPosition = 0;

  final double knobSize = 56;

  @override
  Widget build(BuildContext context) {
    final double maxDrag =
        MediaQuery.of(context).size.width - knobSize - 48;

    return Container(
      height: 70.h,
      padding:  EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color:Color(0xff369e97),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
           Center(
            child: Text(
              "Get Started",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Positioned(
            left: dragPosition,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  dragPosition += details.delta.dx;
                  if (dragPosition < 0) dragPosition = 0;
                  if (dragPosition > maxDrag) dragPosition = maxDrag;
                });
              },
              onHorizontalDragEnd: (_) {
                if (dragPosition > maxDrag * 0.8) {
                  widget.onComplete?.call();
                } else {
                  setState(() {
                    dragPosition = 0;
                  });
                }
              },
              child: Container(
                width: knobSize,
                height: knobSize,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child:  Icon(
                  size: 26,
                  Icons.pets,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}