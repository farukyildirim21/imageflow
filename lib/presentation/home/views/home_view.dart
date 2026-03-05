import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../controllers/home_controller.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/history_item_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      // toolbarHeight: 0 collapses the toolbar to zero — only the status bar
      // area remains, which gets elfOwl background from AppBarTheme.
      appBar: AppBar(toolbarHeight: 0),
      body: Obx(() {
        if (controller.isLoading.value && controller.history.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.burrowingOwl),
          );
        }

        if (controller.history.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(controller),
              Expanded(
                child: EmptyStateWidget(onCapture: controller.goToCapture),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(controller),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.burrowingOwl,
                backgroundColor: AppColors.bgElevated,
                onRefresh: controller.loadHistory,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    0,
                    AppSpacing.md,
                    AppSpacing.xl,
                  ),
                  itemCount: controller.history.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (_, index) {
                    final record = controller.history[index];
                    return HistoryItemCard(
                      record: record,
                      onTap: () => controller.goToDetail(record),
                      onDelete: () => controller.deleteRecord(record.id),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.goToCapture,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Renders the "ImageFlow" heading and optional loading spinner.
  /// Matches .mockup-title: font-size 1rem / font-weight 600,
  /// inside .mockup-body padding (space-md = 16 px).
  Widget _buildTitle(HomeController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text('ImageFlow', style: AppTextStyles.titleSmall),
          ),
          Obx(() => controller.isLoading.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.burrowingOwl,
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
