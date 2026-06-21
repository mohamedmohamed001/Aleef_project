import 'package:aleef/core/theme/app_colors.dart';
import 'package:aleef/core/theme/app_text_styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/models/medical_record_details_model.dart';
import '../provider/medical_record_details_provider.dart';

class MedicalRecordDetailsScreen extends StatefulWidget {
  final String recordId;
  final bool readOnly;

  const MedicalRecordDetailsScreen({
    super.key,
    required this.recordId,
    this.readOnly = false,
  });

  @override
  State<MedicalRecordDetailsScreen> createState() =>
      _MedicalRecordDetailsScreenState();
}

class _MedicalRecordDetailsScreenState
    extends State<MedicalRecordDetailsScreen> {
  late MedicalRecordDetailsProvider _detailsProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _detailsProvider = context.read<MedicalRecordDetailsProvider>();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _detailsProvider.getMedicalRecordDetails(
        widget.recordId,
        useDoctorToken: widget.readOnly,
      );
    });
  }

  @override
  void dispose() {
    _detailsProvider.clear();
    super.dispose();
  }

  String _formatDate(String date) {
    if (date.trim().isEmpty) return 'N/A';
    return date.contains('T') ? date.split('T').first : date;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicalRecordDetailsProvider>(
      builder: (context, provider, _) {
        final record = provider.record;

        return Scaffold(
          backgroundColor: const Color(0xFFF6F8F8),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF6F8F8),
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF101828),
              ),
            ),
            title: Text(
              'Medical Record',
              style: AppTextStyles.title16SemiBold.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF101828),
              ),
            ),
          ),
          body: provider.isLoading
              ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          )
              : provider.errorMessage != null
              ? _ErrorView(
            onRetry: () {
              provider.getMedicalRecordDetails(
                widget.recordId,
                useDoctorToken: widget.readOnly,
              );
            },
          )
              : record == null
              ? const SizedBox.shrink()
              : SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              18.w,
              10.h,
              18.w,
              28.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroCard(
                  record: record,
                  formattedDate: _formatDate(record.date),
                ),
                SizedBox(height: 18.h),
                _DoctorCard(record: record),
                SizedBox(height: 18.h),
                _DetailsCard(
                  record: record,
                  formattedDate: _formatDate(record.date),
                ),
                SizedBox(height: 18.h),
                _DescriptionCard(
                  description: record.description,
                ),
                SizedBox(height: 18.h),
                _AttachmentsSection(
                  attachments: record.attachments,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroCard extends StatelessWidget {
  final MedicalRecordDetailsModel record;
  final String formattedDate;

  const _HeroCard({
    required this.record,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    final String title =
    record.title.trim().isEmpty ? 'Medical Record' : record.title;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.20),
            blurRadius: 22.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -28.w,
            top: -30.h,
            child: Container(
              width: 115.r,
              height: 115.r,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 12.w,
            bottom: -32.h,
            child: Icon(
              Icons.medical_information_rounded,
              color: Colors.white.withOpacity(0.13),
              size: 88.sp,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52.r,
                height: 52.r,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.18),
                  ),
                ),
                child: Icon(
                  Icons.health_and_safety_rounded,
                  color: Colors.white,
                  size: 27.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title16SemiBold.copyWith(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                ),
              ),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _HeroChip(
                    icon: Icons.calendar_month_rounded,
                    text: formattedDate,
                  ),
                  if (record.condition.trim().isNotEmpty)
                    _HeroChip(
                      icon: Icons.local_hospital_rounded,
                      text: record.condition,
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HeroChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 14.sp,
          ),
          SizedBox(width: 5.w),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final MedicalRecordDetailsModel record;

  const _DoctorCard({
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.r,
            backgroundColor: AppColors.primary.withOpacity(0.10),
            backgroundImage:
            record.doctorPic.trim().isNotEmpty ? NetworkImage(record.doctorPic) : null,
            child: record.doctorPic.trim().isEmpty
                ? Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: 25.sp,
            )
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.doctorName.trim().isEmpty
                      ? 'Unknown Doctor'
                      : record.doctorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title16SemiBold.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Assigned Veterinarian',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF7A8794),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.09),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.verified_rounded,
              color: AppColors.primary,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final MedicalRecordDetailsModel record;
  final String formattedDate;

  const _DetailsCard({
    required this.record,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(
            icon: Icons.description_rounded,
            title: 'Record Details',
          ),
          SizedBox(height: 14.h),
          _InfoBox(
            children: [
              _InfoRow(label: 'Title', value: record.title),
              _InfoRow(label: 'Condition', value: record.condition),
              _InfoRow(label: 'Date', value: formattedDate),
            ],
          ),
        ],
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  final String description;

  const _DescriptionCard({
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(
            icon: Icons.notes_rounded,
            title: 'Description',
          ),
          SizedBox(height: 14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFA),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: const Color(0xFFE8EEF0),
              ),
            ),
            child: Text(
              description.trim().isEmpty
                  ? 'No description provided.'
                  : description,
              style: AppTextStyles.body14Regular.copyWith(
                fontSize: 13.sp,
                height: 1.65,
                color: const Color(0xFF4B5563),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentsSection extends StatelessWidget {
  final List<String> attachments;

  const _AttachmentsSection({
    required this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(
            icon: Icons.attach_file_rounded,
            title: 'Attachments',
          ),
          SizedBox(height: 14.h),
          if (attachments.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFA),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: const Color(0xFFE8EEF0),
                ),
              ),
              child: Text(
                'No attachments found.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  color: const Color(0xFF7A8794),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            GridView.builder(
              itemCount: attachments.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final imageUrl = attachments[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _AttachmentPreviewScreen(
                          imageUrl: imageUrl,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(18.r),
                  child: Hero(
                    tag: imageUrl,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18.r),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;

                          return Container(
                            color: const Color(0xFFF3F4F6),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFF3F4F6),
                            child: Icon(
                              Icons.broken_image_rounded,
                              color: const Color(0xFF9CA3AF),
                              size: 30.sp,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _AttachmentPreviewScreen extends StatelessWidget {
  final String imageUrl;

  const _AttachmentPreviewScreen({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: InteractiveViewer(
            minScale: 0.7,
            maxScale: 4,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class _WhiteCard extends StatelessWidget {
  final Widget child;

  const _WhiteCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: const Color(0xFFE8EEF0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _CardTitle({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42.r,
          height: 42.r,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 21.sp,
          ),
        ),
        SizedBox(width: 11.w),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.title16SemiBold.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF111827),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  final List<Widget> children;

  const _InfoBox({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFA),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: const Color(0xFFE8EEF0),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final String safeValue = value.trim().isEmpty ? 'N/A' : value;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92.w,
            child: Text(
              label,
              style: TextStyle(
                color: const Color(0xFF7A8794),
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              safeValue,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: const Color(0xFF111827),
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w900,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorView({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 44.sp,
            ),
            SizedBox(height: 12.h),
            Text(
              'Failed to load medical record',
              style: AppTextStyles.title16SemiBold.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Please try again.',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF7A8794),
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}