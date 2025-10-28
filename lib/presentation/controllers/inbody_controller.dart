import 'package:get/get.dart';

import '../../data/models/inbody_record_model.dart';

class InBodyController extends GetxController {
  final RxList<InBodyRecordModel> records = <InBodyRecordModel>[].obs;

  double get latestWeight => records.isEmpty ? 0 : records.last.weight;
  double get latestBodyFat => records.isEmpty ? 0 : records.last.bodyFat;
  double get latestMuscle => records.isEmpty ? 0 : records.last.muscle;
  double get latestWater => records.isEmpty ? 0 : records.last.water;

  void addRecord(InBodyRecordModel record) {
    records.add(record);
  }

  List<double> metricHistory(double Function(InBodyRecordModel) selector) {
    return records.map(selector).toList();
  }
}
