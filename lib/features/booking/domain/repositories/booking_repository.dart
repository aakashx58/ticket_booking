import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import 'booking.dart';

abstract class BookingRepository {
  Future<Either<Failure, List<Booking>>> getMyBookings({int page = 1, int limit = 20});
  
  Future<Either<Failure, Booking>> getBookingById(String id);
  
  Future<Either<Failure, BookingConfirmation>> createBooking(BookingRequest request);
  
  Future<Either<Failure, void>> cancelBooking(String bookingId, String reason);
  
  Future<Either<Failure, String>> getBookingQRCode(String bookingId);
}