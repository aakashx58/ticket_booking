import 'package:dartz/dartz.dart';
import '../entities/booking.dart';
import '../repositories/booking_repository.dart';
import '../../core/errors/failures.dart';

class GetMyBookingsUseCase {
  final BookingRepository repository;

  GetMyBookingsUseCase(this.repository);

  Future<Either<Failure, List<Booking>>> call({int page = 1, int limit = 20}) {
    return repository.getMyBookings(page: page, limit: limit);
  }
}

class GetBookingByIdUseCase {
  final BookingRepository repository;

  GetBookingByIdUseCase(this.repository);

  Future<Either<Failure, Booking>> call(String id) {
    return repository.getBookingById(id);
  }
}

class CreateBookingUseCase {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  Future<Either<Failure, BookingConfirmation>> call(BookingRequest request) {
    return repository.createBooking(request);
  }
}

class CancelBookingUseCase {
  final BookingRepository repository;

  CancelBookingUseCase(this.repository);

  Future<Either<Failure, void>> call(String bookingId, String reason) {
    return repository.cancelBooking(bookingId, reason);
  }
}

class GetBookingQRCodeUseCase {
  final BookingRepository repository;

  GetBookingQRCodeUseCase(this.repository);

  Future<Either<Failure, String>> call(String bookingId) {
    return repository.getBookingQRCode(bookingId);
  }
}