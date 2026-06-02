import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/services/api_service.dart';
import '../../controllers/trip_tracking_controller.dart';

class TripTrackingScreen extends GetView<TripTrackingController> {
  const TripTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (controller.isMapReady.value &&
              controller.busLocation.value != null) {
            controller.mapController.move(controller.busLocation.value!, 15.0);
          } else {
            debugPrint("الموقع غير جاهز بعد");
          }
        },

        backgroundColor: AppColor.darkgreen,
        child: Icon(Icons.my_location, color: AppColor.white),
      ),
      body: Obx(() {
        final apiService = Get.find<ApiService>();
        if (!apiService.isConnected.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, size: 80, color: AppColor.darkgreen),
                SizedBox(height: 16.h),
                Text("No internet connection, please check your network and try again.".tr),
                ElevatedButton(
                  onPressed: () async {
                    bool connected = await apiService.checkConnection();
                    if (connected) {
                      controller.fetchTripDetails();
                    }
                  },
                  child: Text("إعادة المحاولة".tr),
                ),
              ],
            ),
          );
        }

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.darkgreen),
          );
        }
        return FlutterMap(
          mapController: controller.mapController,
          options: MapOptions(
            initialZoom: 7,
            onMapReady: () => controller.onMapReady(),
          ),
          children: [

            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              additionalOptions: {
                'lang': 'ar',
              },
              userAgentPackageName: 'com.musafer.app',
              errorTileCallback: (tile, error, stackTrace) {},
            ),
            Obx(
              () => PolylineLayer(
                polylines: [
                  Polyline(
                    points: controller.polylinePoints.toList(),
                    strokeWidth: 5,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),

            Obx(() => MarkerLayer(markers: controller.markers.toList())),

            Obx(
              () => controller.busLocation.value != null
                  ? MarkerLayer(
                      markers: [
                        Marker(
                          point: controller.busLocation.value!,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.location_on,
                                color: AppColor.darkgreen,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      }),
    );
  }
}
