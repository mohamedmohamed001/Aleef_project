import 'package:aleef/features/store/presentation/models/product_model.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class DetailsHeaderSection extends StatefulWidget {
  final List<dynamic> imagePath;
  final VoidCallback onBackPressed;
  final String discount;

  const DetailsHeaderSection({
    super.key,
    required this.imagePath,
    required this.onBackPressed,
    required this.discount,
  });

  @override
  State<DetailsHeaderSection> createState() => _DetailsHeaderSectionState();
}

class _DetailsHeaderSectionState extends State<DetailsHeaderSection> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        /// 🖼️ Image Background
        SizedBox(
          width: double.infinity,
          height: 340.h,
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28.r),
                    bottomRight: Radius.circular(28.r),
                  ),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 300.h,
                      viewportFraction: 1,
                      enableInfiniteScroll: true,
                      autoPlay: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    ),
                    items: widget.imagePath.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return SizedBox(
                            width: double.infinity,
                            child: Image.network(i.url, fit: BoxFit.cover),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imagePath.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: currentIndex == index ? 20.w : 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// 🔝 Top Controls (Back + Discount)
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              children: [
                /// 🔙 Back Button
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Color(0xFF1D1E20),
                    ),
                    onPressed: widget.onBackPressed,
                  ),
                ),

                SizedBox(width: 10.w),
                Spacer(),

                widget.discount != "0"
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          "${widget.discount}%",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
