import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/network/api_service.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<Either<Failure, List<BookingModel>>> getMyBookings({int page = 1, int limit = 20});
  
  Future<Either<Failure, BookingModel>> getBookingById(String id);
  
  Future<Either<Failure, BookingConfirmationModel>> createBooking(BookingRequestModel request);
  
  Future<Either<Failure, void>> cancelBooking(String bookingId, String reason);
  
  Future<Either<Failure, String>> getBookingQRCode(String bookingId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiService _apiService;

  BookingRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, List<BookingModel>>> getMyBookings({int page = 1, int limit = 20}) async {
    try {
      final response = await _apiService.get('/bookings', queryParameters: {
        'page': page,
        'limit': limit,
      });
      final data = response.data['data'] as List;
      return Right(data.map((e) => BookingModel.fromJson(e)).toList());
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingModel>> getBookingById(String id) async {
    try {
      final response = await _apiService.get('/bookings/$id');
      return Right(BookingModel.fromJson(response.data['data']));
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingConfirmationModel>> createBooking(BookingRequestModel request) async {
    try {
      final response = await _apiService.post('/bookings', data: request.toJson());
      return Right(BookingConfirmationModel.fromJson(response.data['data']));
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelBooking(String bookingId, String reason) async {
    try {
      await _apiService.post('/bookings/$bookingId/cancel', data: {'reason': reason});
      return const Right(null);
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getBookingQRCode(String bookingId) async {
    try {
      final response = await _apiService.get('/bookings/$bookingId/qr-code');
      return Right(response.data['data']['qr_code_url']);
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }
}