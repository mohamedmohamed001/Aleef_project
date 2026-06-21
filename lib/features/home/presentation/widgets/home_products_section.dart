import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeProductData {
  final String id;
  final String name;
  final String imageUrl;
  final String price;

  const HomeProductData({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });
}

class HomeProductsSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<HomeProductData> products;
  final bool isLoading;
  final VoidCallback? onViewAllTap;
  final void Function(HomeProductData product)? onProductTap;

  const HomeProductsSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.products,
    this.isLoading = false,
    this.onViewAllTap,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _HomeProductsLoading();
    }

    if (products.isEmpty) {
      return const _EmptyProductsCard();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFF101828),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF667085),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: onViewAllTap,
              borderRadius: BorderRadius.circular(100.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                child: Row(
                  children: [
                    Text(
                      "View all",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.primary,
                      size: 12.sp,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 14.h),

        SizedBox(
          height: 176.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: products.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final product = products[index];

              return _HomeProductCard(
                product: product,
                onTap: () => onProductTap?.call(product),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HomeProductCard extends StatelessWidget {
  final HomeProductData product;
  final VoidCallback? onTap;

  const _HomeProductCard({
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 136.w,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24.r),
          child: Ink(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.045),
                  blurRadius: 18.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 86.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.r),
                    child: product.imageUrl.trim().isEmpty
                        ? Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.primary,
                      size: 34.sp,
                    )
                        : Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.primary,
                        size: 34.sp,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF101828),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),

                const Spacer(),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.price,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Container(
                      width: 28.r,
                      height: 28.r,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeProductsLoading extends StatelessWidget {
  const _HomeProductsLoading();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 176.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (_, _) => SizedBox(width: 12.w),
        itemBuilder: (_, _) {
          return Container(
            width: 136.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyProductsCard extends StatelessWidget {
  const _EmptyProductsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.primary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              "No products available now.",
              style: TextStyle(
                color: const Color(0xFF101828),
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}