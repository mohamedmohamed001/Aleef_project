import 'dart:io';

import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final bool canSend;
  final bool isUploadingImage;
  final File? selectedImage;
  final String? uploadedImageUrl;
  final VoidCallback onSend;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.canSend,
    required this.onSend,
    required this.onPickImage,
    required this.onRemoveImage,
    this.isUploadingImage = false,
    this.selectedImage,
    this.uploadedImageUrl,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _handleSendTap() async {
    if (_isSending) return;
    if (!widget.canSend) return;

    setState(() => _isSending = true);

    widget.onSend();

    if (!mounted) return;
    setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasSelectedImage = widget.selectedImage != null;
    final bool hasUploadedImage =
        widget.uploadedImageUrl != null && widget.uploadedImageUrl!.isNotEmpty;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.055),
              blurRadius: 18.r,
              offset: Offset(0, -6.h),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasSelectedImage)
                _SelectedImagePreview(
                  image: widget.selectedImage!,
                  isUploading: widget.isUploadingImage,
                  isReady: hasUploadedImage && !widget.isUploadingImage,
                  onRemove: widget.onRemoveImage,
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: widget.isUploadingImage ? null : widget.onPickImage,
                    child: Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.09),
                        shape: BoxShape.circle,
                      ),
                      child: widget.isUploadingImage
                          ? Padding(
                        padding: EdgeInsets.all(10.r),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: AppColors.primary,
                        ),
                      )
                          : Icon(
                        Icons.image_outlined,
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 42.h,
                        maxHeight: 108.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F6F6),
                        borderRadius: BorderRadius.circular(22.r),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.035),
                        ),
                      ),
                      child: TextField(
                        controller: widget.controller,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) {
                          if (widget.canSend) _handleSendTap();
                        },
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF1F2937),
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: hasSelectedImage
                              ? 'Add a caption...'
                              : 'Type a message...',
                          hintStyle: TextStyle(
                            color: const Color(0xFF9CA3AF),
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 11.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: widget.canSend ? _handleSendTap : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                      width: 42.r,
                      height: 42.r,
                      decoration: BoxDecoration(
                        color: widget.canSend
                            ? AppColors.primary
                            : AppColors.primary.withOpacity(0.35),
                        shape: BoxShape.circle,
                        boxShadow: widget.canSend
                            ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.24),
                            blurRadius: 12.r,
                            offset: Offset(0, 5.h),
                          ),
                        ]
                            : [],
                      ),
                      child: _isSending
                          ? Padding(
                        padding: EdgeInsets.all(11.r),
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                          : Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 19.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedImagePreview extends StatelessWidget {
  final File image;
  final bool isUploading;
  final bool isReady;
  final VoidCallback onRemove;

  const _SelectedImagePreview({
    required this.image,
    required this.isUploading,
    required this.isReady,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.file(
                image,
                width: 92.r,
                height: 92.r,
                fit: BoxFit.cover,
              ),
            ),
            if (isUploading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.36),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 24.r,
                      height: 24.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 5.r,
              right: 5.r,
              child: GestureDetector(
                onTap: isUploading ? null : onRemove,
                child: Container(
                  width: 24.r,
                  height: 24.r,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.58),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ),
            ),
            if (isReady)
              Positioned(
                left: 5.r,
                bottom: 5.r,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 12.sp,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Ready',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}