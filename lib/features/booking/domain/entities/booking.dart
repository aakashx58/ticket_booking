import 'package:equatable/equatable.dart';

class Booking extends Equatable {
  final String id;
  final String eventId;
  final String eventTitle;
  final String? eventImageUrl;
  final DateTime eventDate;
  final String venueName;
  final String venueAddress;
  final String ticketTypeId;
  final String ticketTypeName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final double fees;
  final double taxes;
  final String status;
  final String? confirmationCode;
  final String? qrCodeUrl;
  final DateTime bookedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;

  const Booking({
    required this.id,
    required this.eventId,
    required this.eventTitle,
    this.eventImageUrl,
    required this.eventDate,
    required this.venueName,
    required this.venueAddress,
    required this.ticketTypeId,
    required this.ticketTypeName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.fees,
    required this.taxes,
    required this.status,
    this.confirmationCode,
    this.qrCodeUrl,
    required this.bookedAt,
    this.cancelledAt,
    this.cancellationReason,
  });

  bool get isUpcoming => eventDate.isAfter(DateTime.now());
  bool get isCancelled => status == 'cancelled';
  bool get isConfirmed => status == 'confirmed';
  bool get canCancel => isUpcoming && isConfirmed;

  @override
  List<Object?> get props => [
    id,
    eventId,
    eventTitle,
    eventImageUrl,
    eventDate,
    venueName,
    venueAddress,
    ticketTypeId,
    ticketTypeName,
    quantity,
    unitPrice,
    totalPrice,
    fees,
    taxes,
    status,
    confirmationCode,
    qrCodeUrl,
    bookedAt,
    cancelledAt,
    cancellationReason,
  ];
}

class BookingRequest extends Equatable {
  final String eventId;
  final String ticketTypeId;
  final int quantity;
  final String? promoCode;

  const BookingRequest({
    required this.eventId,
    required this.ticketTypeId,
    required this.quantity,
    this.promoCode,
  });

  @override
  List<Object?> get props => [eventId, ticketTypeId, quantity, promoCode];
}

class BookingConfirmation extends Equatable {
  final String bookingId;
  final String confirmationCode;
  final String qrCodeUrl;
  final double totalAmount;
  final DateTime bookedAt;

  const BookingConfirmation({
    required this.bookingId,
    required this.confirmationCode,
    required this.qrCodeUrl,
    required this.totalAmount,
    required this.bookedAt,
  });

  @override
  List<Object> get props => [bookingId, confirmationCode, qrCodeUrl, totalAmount, bookedAt];
}