import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'data/models/processing_record_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ProcessingRecordModelAdapter());

  runApp(const ImageFlowApp());
}

class ImageFlowApp extends StatelessWidget {
  const ImageFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ImageFlow',
      theme: AppTheme.dark,
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
