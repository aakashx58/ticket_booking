import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/booking.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

@freezed
class BookingModel with _$BookingModel {
  const factory BookingModel({
    required String id,
    required String eventId,
    required String eventTitle,
    String? eventImageUrl,
    required DateTime eventDate,
    required String venueName,
    required String venueAddress,
    required String ticketTypeId,
    required String ticketTypeName,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    required double fees,
    required double taxes,
    required String status,
    String? confirmationCode,
    String? qrCodeUrl,
    required DateTime bookedAt,
    DateTime? cancelledAt,
    String? cancellationReason,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);
}

@freezed
class BookingRequestModel with _$BookingRequestModel {
  const factory BookingRequestModel({
    required String eventId,
    required String ticketTypeId,
    required int quantity,
    String? promoCode,
  }) = _BookingRequestModel;

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) => _$BookingRequestModelFromJson(json);
}

@freezed
class BookingConfirmationModel with _$BookingConfirmationModel {
  const factory BookingConfirmationModel({
    required String bookingId,
    required String confirmationCode,
    required String qrCodeUrl,
    required double totalAmount,
    required DateTime bookedAt,
  }) = _BookingConfirmationModel;

  factory BookingConfirmationModel.fromJson(Map<String, dynamic> json) => _$BookingConfirmationModelFromJson(json);
}

extension BookingModelX on BookingModel {
  Booking toEntity() {
    return Booking(
      id: id,
      eventId: eventId,
      eventTitle: eventTitle,
      eventImageUrl: eventImageUrl,
      eventDate: eventDate,
      venueName: venueName,
      venueAddress: venueAddress,
      ticketTypeId: ticketTypeId,
      ticketTypeName: ticketTypeName,
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      fees: fees,
      taxes: taxes,
      status: status,
      confirmationCode: confirmationCode,
      qrCodeUrl: qrCodeUrl,
      bookedAt: bookedAt,
      cancelledAt: cancelledAt,
      cancellationReason: cancellationReason,
    );
  }
}

extension BookingRequestX on BookingRequest {
  BookingRequestModel toModel() {
    return BookingRequestModel(
      eventId: eventId,
      ticketTypeId: ticketTypeId,
      quantity: quantity,
      promoCode: promoCode,
    );
  }
}

extension BookingConfirmationModelX on BookingConfirmationModel {
  BookingConfirmation toEntity() {
    return BookingConfirmation(
      bookingId: bookingId,
      confirmationCode: confirmationCode,
      qrCodeUrl: qrCodeUrl,
      totalAmount: totalAmount,
      bookedAt: bookedAt,
    );
  }
}