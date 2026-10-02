part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class MyBookingsLoadRequested extends BookingEvent {
  final int page;
  final bool loadMore;

  const MyBookingsLoadRequested({this.page = 1, this.loadMore = false});

  @override
  List<Object> get props => [page, loadMore];
}

class MyBookingsRefreshRequested extends BookingEvent {
  const MyBookingsRefreshRequested();
}

class BookingLoadRequested extends BookingEvent {
  final String bookingId;

  const BookingLoadRequested({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}

class BookingCreateRequested extends BookingEvent {
  final String eventId;
  final String ticketTypeId;
  final int quantity;
  final String? promoCode;

  const BookingCreateRequested({
    required this.eventId,
    required this.ticketTypeId,
    required this.quantity,
    this.promoCode,
  });

  @override
  List<Object?> get props => [eventId, ticketTypeId, quantity, promoCode];
}

class BookingCancelRequested extends BookingEvent {
  final String bookingId;
  final String reason;

  const BookingCancelRequested({required this.bookingId, required this.reason});

  @override
  List<Object> get props => [bookingId, reason];
}

class BookingQRCodeRequested extends BookingEvent {
  final String bookingId;

  const BookingQRCodeRequested({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}