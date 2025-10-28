import 'package:get/get.dart';

import '../../data/models/booking_model.dart';

class ScheduleController extends GetxController {
  final RxList<BookingModel> bookings = <BookingModel>[].obs;

  void addBooking(BookingModel booking) {
    bookings.add(booking);
  }

  void cancelBooking(String id) {
    bookings.removeWhere((element) => element.id == id);
  }
}
