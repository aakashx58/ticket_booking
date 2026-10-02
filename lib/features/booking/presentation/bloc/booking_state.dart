part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingLoading extends BookingState {
  final bool isLoadMore;

  const BookingLoading({this.isLoadMore = false});

  @override
  List<Object> get props => [isLoadMore];
}

class MyBookingsLoaded extends BookingState {
  final List<Booking> bookings;
  final bool hasReachedMax;
  final int currentPage;

  const MyBookingsLoaded({
    required this.bookings,
    required this.hasReachedMax,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [bookings, hasReachedMax, currentPage];
}

class BookingLoaded extends BookingState {
  final Booking booking;

  const BookingLoaded({required this.booking});

  @override
  List<Object> get props => [booking];
}

class BookingCreated extends BookingState {
  final BookingConfirmation confirmation;

  const BookingCreated({required this.confirmation});

  @override
  List<Object> get props => [confirmation];
}

class BookingCancelled extends BookingState {
  const BookingCancelled();

  @override
  List<Object> get props => [];
}

class BookingQRCodeLoaded extends BookingState {
  final String qrCodeUrl;

  const BookingQRCodeLoaded({required this.qrCodeUrl});

  @override
  List<Object> get props => [qrCodeUrl];
}

class BookingError extends BookingState {
  final String message;

  const BookingError({required this.message});

  @override
  List<Object> get props => [message];
}