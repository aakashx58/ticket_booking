import 'package:dartz/dartz.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/booking_remote_data_source.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;

  BookingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Booking>>> getMyBookings({int page = 1, int limit = 20}) async {
    final result = await _remoteDataSource.getMyBookings(page: page, limit: limit);
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((m) => m.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, Booking>> getBookingById(String id) async {
    final result = await _remoteDataSource.getBookingById(id);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, BookingConfirmation>> createBooking(BookingRequest request) async {
    final requestModel = request.toModel();
    final result = await _remoteDataSource.createBooking(requestModel);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, void>> cancelBooking(String bookingId, String reason) async {
    return await _remoteDataSource.cancelBooking(bookingId, reason);
  }

  @override
  Future<Either<Failure, String>> getBookingQRCode(String bookingId) async {
    return await _remoteDataSource.getBookingQRCode(bookingId);
  }
}