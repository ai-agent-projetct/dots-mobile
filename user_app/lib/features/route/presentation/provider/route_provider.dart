import 'package:flutter/material.dart';
import 'package:user/constants/app_images.dart';

class RouteProvider extends ChangeNotifier {
  final searchController = TextEditingController();
  final List<Map<String, String>> vehicleRoutes = [
    {"name": "Eletric", "image": AppImages.carIcon},
    {"name": "Mini Auto", "image": AppImages.carIcon},
    {"name": "Macro", "image": AppImages.carIcon},
    {"name": "Xuv", "image": AppImages.carIcon},
  ];
}
