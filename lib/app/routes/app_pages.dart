import 'package:get/get.dart';
import '../../presentation/home/bindings/home_binding.dart';
import '../../presentation/home/views/home_view.dart';
import '../../presentation/capture/bindings/capture_binding.dart';
import '../../presentation/capture/views/capture_view.dart';
import '../../presentation/processing/bindings/processing_binding.dart';
import '../../presentation/processing/views/processing_view.dart';
import '../../presentation/result/bindings/result_binding.dart';
import '../../presentation/result/views/result_view.dart';
import '../../presentation/history_detail/bindings/history_detail_binding.dart';
import '../../presentation/history_detail/views/history_detail_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.capture,
      page: () => const CaptureView(),
      binding: CaptureBinding(),
    ),
    GetPage(
      name: AppRoutes.processing,
      page: () => const ProcessingView(),
      binding: ProcessingBinding(),
    ),
    GetPage(
      name: AppRoutes.result,
      page: () => const ResultView(),
      binding: ResultBinding(),
    ),
    GetPage(
      name: AppRoutes.historyDetail,
      page: () => const HistoryDetailView(),
      binding: HistoryDetailBinding(),
    ),
  ];
}
