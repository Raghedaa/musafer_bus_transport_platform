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

    controller.screenContext = context;


    return Scaffold(

      floatingActionButton: FloatingActionButton(
        onPressed: controller.centerOnBus,
        backgroundColor: AppColor.darkgreen,
        child: const Icon(Icons.directions_bus, color: Colors.white),
      ),


      body:Stack(
          children: [
            Obx(() {
            final apiService = Get.find<ApiService>();
            if (controller.hasError.value) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text("No Internet Connection".tr),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: controller.retryLoading,
                      icon: const Icon(Icons.refresh),
                      label: Text("Retry".tr),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColor.darkgreen),
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
            initialZoom: 15,
            initialCenter:
                controller.busLocation.value ?? const LatLng(33.486, 36.339),
            onMapReady: () => controller.onMapReady(),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.musafer.app',
              tileBuilder: (context, child, tile) {
                return Container(
                  color: Colors.grey[200],
                  child: child,
                );
              },
              errorTileCallback: (tile, error, stackTrace) {
                debugPrint('❌ Tile Error: $error');
              },
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
                    width: 40,
                    height: 40,
                    point: controller.busLocation.value!,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColor.darkgreen,
                        shape: BoxShape.circle,
                      ),
                      child: Obx(() => Container(
                        decoration: BoxDecoration(
                          color: controller.isBusOffline.value ? Colors.grey : AppColor.darkgreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.location_searching, color: Colors.white, size: 25),
                        ),
                      ))

                    ),
                  ),
                ],
              )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      }),


            Positioned(
              top: 40,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(Icons.location_on, Colors.green, "legend_start_point"),
                    _buildLegendItem(Icons.coffee, Colors.orange, "legend_rest_area"),
                    _buildLegendItem(Icons.flag, Colors.red, "legend_arrival"),
                    _buildLegendItem(Icons.location_searching, AppColor.darkgreen, "legend_bus_location"),
                  ],
                ),
              ),
            ),
    ]));
  }
}


Widget _buildLegendItem(IconData icon, Color color, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(text.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}