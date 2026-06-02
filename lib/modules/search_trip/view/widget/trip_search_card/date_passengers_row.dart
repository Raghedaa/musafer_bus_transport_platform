import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/modules/search_trip/controllers/search_controller.dart';
import 'package:intl/intl.dart';

class DateAndPassengersRow extends GetView<TripSearchController> {
  const DateAndPassengersRow({super.key});

  static const List<String> arabicMonths = [
    "كانون الثاني", "شباط", "آذار", "نيسان",
    "أيار", "حزيران", "تموز", "آب",
    "أيلول", "تشرين الأول", "تشرين الثاني", "كانون الأول"
  ];

  static const List<String> arabicWeekdays = [
    "الأحد", "الإثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت"
  ];

  Future<DateTime?> _showCustomDatePicker(BuildContext context) async {
    DateTime? selectedDate = DateTime.now();
    DateTime currentDisplayMonth = DateTime.now();

    bool isArabic = Get.locale?.languageCode == 'ar';

    final List<String> monthsList = isArabic ? arabicMonths : [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];

    final List<String> weekdaysList = isArabic ? arabicWeekdays : [
      "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
    ];

    return await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              content: SizedBox(
                width: 380.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.chevron_left, color: AppColor.darkgreen, size: 28.sp),
                          onPressed: () {
                            setState(() {
                              currentDisplayMonth = DateTime(
                                currentDisplayMonth.year,
                                currentDisplayMonth.month + 1,
                              );
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        Text(
                          "${monthsList[currentDisplayMonth.month - 1]} ${currentDisplayMonth.year}",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.darkgreen,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.chevron_right, color: AppColor.darkgreen, size: 28.sp),
                          onPressed: () {
                            setState(() {
                              currentDisplayMonth = DateTime(
                                currentDisplayMonth.year,
                                currentDisplayMonth.month - 1,
                              );
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: weekdaysList.map((day) {
                          return Expanded(
                            child: Text(
                              day,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isArabic ? 12.sp : 10.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColor.darkgreen,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    _buildDaysGrid(
                      currentDisplayMonth,
                      selectedDate,
                          (date) {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                      isArabic,
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
              actionsPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: Text(isArabic ? "إلغاء" : "Cancel",
                      style: TextStyle(color: AppColor.darkgreen, fontSize: 14.sp)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(selectedDate),
                  child: Text(isArabic ? "تأكيد" : "Confirm",
                      style: TextStyle(color: AppColor.darkgreen, fontSize: 14.sp)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDaysGrid(DateTime month, DateTime? selectedDate, Function(DateTime) onDateSelected, bool isArabic) {
    DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    int startingWeekday = firstDayOfMonth.weekday % 7;
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    List<Widget> days = [];

    for (int i = 0; i < startingWeekday; i++) {
      days.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      DateTime currentDate = DateTime(month.year, month.month, day);
      bool isSelected = selectedDate != null &&
          selectedDate.year == currentDate.year &&
          selectedDate.month == currentDate.month &&
          selectedDate.day == currentDate.day;
      bool isPast = currentDate.isBefore(DateTime.now().subtract(const Duration(days: 1)));

      days.add(
        GestureDetector(
          onTap: isPast ? null : () => onDateSelected(currentDate),
          child: Container(
            margin: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColor.darkgreen : Colors.transparent,
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isPast
                      ? Colors.grey.shade400
                      : (isSelected ? Colors.white : AppColor.black),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.2,
        mainAxisSpacing: 4.h,
        crossAxisSpacing: 2.w,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) => days[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == 'ar';

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              DateTime? date = await _showCustomDatePicker(context);
              if (date != null) {
                controller.updateDateValue(DateFormat('yyyy-MM-dd').format(date));
              }
            },
            child: Obx(() {
              String displayDate = controller.departureDate.value;
              try {
                DateTime dt = DateTime.parse(controller.departureDate.value);

                if (isArabic) {
                  String dayName = arabicWeekdays[dt.weekday % 7];
                  displayDate = "$dayName ${dt.day} ${arabicMonths[dt.month - 1]}";
                } else {
                  String formatted = DateFormat('EEEE, MMMM d', 'en_US').format(dt);
                  displayDate = formatted;
                }
              } catch (_) {}

              return _buildInfo(
                  Icons.calendar_today,
                  "DEPARTURE DATE".tr,
                  displayDate
              );
            }),
          ),
        ),

        Container(width: 1, height: 30.h, color: AppColor.primaryGrey),
        SizedBox(width: 16.w),

        Expanded(
          child: InkWell(
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: AppColor.darkgreen,
                        onPrimary: Colors.white,
                        primaryContainer: AppColor.darkgreen,
                        onPrimaryContainer: Colors.white,
                      ),
                      timePickerTheme: TimePickerThemeData(
                        backgroundColor: Colors.white,
                        hourMinuteTextColor: AppColor.darkgreen,
                        dialHandColor: AppColor.darkgreen,
                        dialBackgroundColor: AppColor.darkgreen.withOpacity(0.1),
                        hourMinuteColor: AppColor.darkgreen.withOpacity(0.1),
                        dayPeriodColor: AppColor.darkgreen.withOpacity(0.1),
                        dayPeriodTextColor: AppColor.darkgreen,
                        entryModeIconColor: AppColor.darkgreen,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColor.darkgreen,
                        ),
                      ),
                    ),
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        alwaysUse24HourFormat: false,
                      ),
                      child: child!,
                    ),
                  );
                },
              );
              if (pickedTime != null) {
                controller.updateTimeValue(
                    "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}"
                );
              }
            },
            child: Obx(() {
              String displayTime = controller.departureTime.value;
              if (displayTime != "Select Time") {
                try {
                  final parts = displayTime.split(':');
                  DateTime dt = DateTime(2026, 1, 1, int.parse(parts[0]), int.parse(parts[1]));

                  if (isArabic) {
                    String formatted = DateFormat('h:mm a', 'en_US').format(dt);
                    displayTime = formatted
                        .replaceAll("AM", "صباحاً")
                        .replaceAll("PM", "مساءً");
                  } else {
                    displayTime = DateFormat('h:mm a', 'en_US').format(dt);
                  }
                } catch (_) {}
              }
              return _buildInfo(
                  Icons.access_time_rounded,
                  "DEPARTURE TIME".tr,
                  displayTime.tr
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: AppColor.grey, size: 18.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 10.sp, color: AppColor.grey),
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}