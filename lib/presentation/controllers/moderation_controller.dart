import 'package:get/get.dart';

import '../../application/services/moderation_service.dart';
import '../../data/models/report_model.dart';
import 'mixins/guarded_controller_mixin.dart';

class ModerationController extends GetxController with GuardedControllerMixin {
  ModerationController(this._moderationService);

  final ModerationService _moderationService;

  List<ReportModel> get queue => _moderationService.queue;
  List<ReportModel> get closed => _moderationService.closed;
  RxList<String> get bannedWords => _moderationService.bannedWords;

  @override
  void onInit() {
    super.onInit();
    _moderationService.load();
  }

  Future<void> approve(String reportId) => _moderationService.resolve(reportId, 'approved');

  Future<void> reject(String reportId) => _moderationService.resolve(reportId, 'rejected');

  Future<void> updateWords(List<String> words) => _moderationService.updateBannedWords(words);

  Future<ReportModel> report(String postId, String reason) => _moderationService.submitReport(postId: postId, reason: reason);

  bool hasFlaggedWords(String text) => _moderationService.containsFlaggedWords(text);
}
