import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../data/models/complaint_model.dart';

class ComplaintCard extends StatelessWidget {
  final ComplaintModel complaint;
  final VoidCallback? onTap;

  const ComplaintCard({super.key, required this.complaint, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Row: Category & Status ──
                Row(
                  children: [
                    if (complaint.categoryName != null)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColor.darkgreen.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          complaint.categoryName!,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColor.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    const Spacer(),
                    _StatusBadge(status: complaint.status),
                  ],
                ),
                SizedBox(height: 12.h),

                Text(
                  complaint.description,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColor.black,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16.h),

                Row(
                  children: [
                    _buildMetaItem(Icons.directions_bus, '${'Trip'.tr}: ${complaint.tripId}', complaint.tripId != null),
                    SizedBox(width: 12.w),
                    _buildMetaItem(Icons.receipt_long, '${'Booking'.tr}: ${complaint.bookingId}', complaint.bookingId != null),
                    const Spacer(),
                    Text(
                      _formatDate(complaint.createdAt ?? ""),
                      style: TextStyle(fontSize: 10.sp, color: AppColor.black,),
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

  Widget _buildMetaItem(IconData icon, String text, bool show) {
    if (!show) return const SizedBox.shrink();
    return Row(
      children: [
        Icon(icon, size: 12.sp, color: AppColor.primaryGrey),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(fontSize: 11.sp, color: AppColor.primaryGrey),
        ),
      ],
    );
  }

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return raw;
    }
  }
}
class _StatusBadge extends StatelessWidget {
  final String? status;
  const _StatusBadge({super.key, this.status});


  @override
  Widget build(BuildContext context) {

    // نقوم بتنظيف الحالة (trim) وتوحيدها (toLowerCase) لضمان المطابقة
    final String cleanStatus = (status ?? 'pending').trim().toLowerCase();
    final Color color = _getColor(cleanStatus);

    debugPrint("Status is: $status, Color is: $color");
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        // تأكدنا أن اللون هنا هو لون صريح
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        cleanStatus.tr.toUpperCase(),
        style: TextStyle(
          fontSize: 9.sp,
          color: color, // لون النص
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getColor(String status) {
    switch (status?.toLowerCase()) {
      case 'resolved':
        return AppColor.green;
      case 'rejected':
        return AppColor.red;
      case 'in_progress':
        return AppColor.orange;
      case 'pending':
        return AppColor.amber;
      default:
        return AppColor.primaryGrey;
    }
  }
}

