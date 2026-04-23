import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';

import '../../../core/constants/app_image.dart';
import '../../../data/models/onboarding_model.dart';


List<OnBoradingModel> onBoardingList = [
  OnBoradingModel(
    title: "Welcome to\nOmniBus".tr,
    image: AppImageAsset.onBoardingImageOne,
    body: "The easiest way to book your intercity trips.".tr,
    rotation: 0,
    width: 350,
    height: 350,
    borderWidth: 0,
    borderColor: AppColor.darkgreen,
  ),
  OnBoradingModel(
    title: "Quick Search".tr,
    image: AppImageAsset.onBoardingImageTwo,
    body: "Find and compare hundreds of trips.".tr,
    rotation: -0.1,
    width: 400,
    height: 340,
  ),
  OnBoradingModel(
    title: "Choose Your Seat".tr,
    image: AppImageAsset.onBoardingImageThree,
    body: "Select your favorite seat visually and securely with our interactive map.".tr,
    width: 350,
    height: 350,
    borderWidth: 2,

  ),
  OnBoradingModel(
    title:  "Digital Ticket".tr,
    image: AppImageAsset.onBoardingImageFour,
    body: "No need for paper. Your ticket is always with you, even offline.".tr,
    width: 350,
    height: 350,
    borderWidth: 2,
  ),

];

