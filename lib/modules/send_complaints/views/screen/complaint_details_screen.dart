import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_color.dart';
import '../../../../data/models/complaint_details_model.dart';
import '../../../../data/providers/complaint_provider.dart';
import '../../../../data/repositories/trip_repository.dart';
import '../widgets/complaint_details_screen/attachment_section.dart';
import '../widgets/complaint_details_screen/info_card.dart';
import '../widgets/complaint_details_screen/trip_card.dart';




class ComplaintDetailsScreen extends StatelessWidget {
  final int complaintId;
   ComplaintDetailsScreen({super.key, required this.complaintId});

  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(title: Text("complaint_details".tr)),
      body: FutureBuilder(
        future: Future.wait([
          ComplaintsProvider().getComplaintDetails(complaintId),
          TripRepository().fetchCities()
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                      size: 60.sp,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "no internet connection".tr,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.darkgreen),
            );
          }

          final model = ComplaintDetailsModel.fromJson(
              snapshot.data![0].data['data'],
              snapshot.data![1]
          );
          return ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              InfoCard(model: model),
              SizedBox(height: 16.h),
              TripCard(model: model), // الودجت الجديدة
              SizedBox(height: 16.h),
              AttachmentsSection(urls: model.attachmentUrls),
              SizedBox(height: 30.h,)
            ],
          );
        },
      ),
    );
  }
}