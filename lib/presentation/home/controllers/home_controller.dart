import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/processing_record.dart';
import '../../../domain/usecases/get_history_usecase.dart';
import '../../../domain/usecases/delete_record_usecase.dart';
import '../../../app/routes/app_routes.dart';
import '../../capture/controllers/capture_controller.dart';
import '../../capture/views/capture_view.dart';

class HomeController extends GetxController {
  final GetHistoryUseCase _getHistory;
  final DeleteRecordUseCase _deleteRecord;

  HomeController({
    required GetHistoryUseCase getHistory,
    required DeleteRecordUseCase deleteRecord,
  })  : _getHistory = getHistory,
        _deleteRecord = deleteRecord;

  final RxList<ProcessingRecord> history = <ProcessingRecord>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    isLoading.value = true;
    try {
      final records = await _getHistory();
      history.assignAll(records);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteRecord(String id) async {
    await _deleteRecord(id);
    history.removeWhere((r) => r.id == id);
  }

  /// Shows the capture bottom sheet.
  /// CaptureController is registered lazily (fenix: re-creates if disposed).
  void goToCapture() {
    Get.lazyPut<CaptureController>(() => CaptureController(), fenix: true);
    Get.bottomSheet(
      const CaptureView(),
      backgroundColor: Colors.transparent, // CaptureView handles its own bg
      isScrollControlled: false,
    );
  }

  void goToDetail(ProcessingRecord record) {
    Get.toNamed(AppRoutes.historyDetail, arguments: record);
  }
}
