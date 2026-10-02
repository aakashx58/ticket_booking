import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/booking.dart';
import '../../domain/usecases/booking_usecases.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetMyBookingsUseCase _getMyBookingsUseCase;
  final GetBookingByIdUseCase _getBookingByIdUseCase;
  final CreateBookingUseCase _createBookingUseCase;
  final CancelBookingUseCase _cancelBookingUseCase;
  final GetBookingQRCodeUseCase _getBookingQRCodeUseCase;

  BookingBloc({
    required GetMyBookingsUseCase getMyBookingsUseCase,
    required GetBookingByIdUseCase getBookingByIdUseCase,
    required CreateBookingUseCase createBookingUseCase,
    required CancelBookingUseCase cancelBookingUseCase,
    required GetBookingQRCodeUseCase getBookingQRCodeUseCase,
  })  : _getMyBookingsUseCase = getMyBookingsUseCase,
        _getBookingByIdUseCase = getBookingByIdUseCase,
        _createBookingUseCase = createBookingUseCase,
        _cancelBookingUseCase = cancelBookingUseCase,
        _getBookingQRCodeUseCase = getBookingQRCodeUseCase,
        super(const BookingInitial()) {
    on<MyBookingsLoadRequested>(_onMyBookingsLoadRequested);
    on<MyBookingsRefreshRequested>(_onMyBookingsRefreshRequested);
    on<BookingLoadRequested>(_onBookingLoadRequested);
    on<BookingCreateRequested>(_onBookingCreateRequested);
    on<BookingCancelRequested>(_onBookingCancelRequested);
    on<BookingQRCodeRequested>(_onBookingQRCodeRequested);
  }

  Future<void> _onMyBookingsLoadRequested(
    MyBookingsLoadRequested event,
    Emitter<BookingState> emit,
  ) async {
    if (event.loadMore) {
      final currentState = state;
      if (currentState is MyBookingsLoaded && currentState.hasReachedMax) return;
      emit(BookingLoading(isLoadMore: true));
    } else {
      emit(const BookingLoading());
    }

    final result = await _getMyBookingsUseCase(page: event.page);
    result.fold(
      (failure) => emit(BookingError(message: failure.message)),
      (bookings) {
        final currentState = state;
        if (event.loadMore && currentState is MyBookingsLoaded) {
          final allBookings = [...currentState.bookings, ...bookings];
          emit(MyBookingsLoaded(
            bookings: allBookings,
            hasReachedMax: bookings.length < 20,
            currentPage: event.page,
          ));
        } else {
          emit(MyBookingsLoaded(
            bookings: bookings,
            hasReachedMax: bookings.length < 20,
            currentPage: event.page,
          ));
        }
      },
    );
  }

  Future<void> _onMyBookingsRefreshRequested(
    MyBookingsRefreshRequested event,
    Emitter<BookingState> emit,
  ) async {
    final result = await _getMyBookingsUseCase(page: 1);
    result.fold(
      (failure) => emit(BookingError(message: failure.message)),
      (bookings) => emit(MyBookingsLoaded(
        bookings: bookings,
        hasReachedMax: bookings.length < 20,
        currentPage: 1,
      )),
    );
  }

  Future<void> _onBookingLoadRequested(
    BookingLoadRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    final result = await _getBookingByIdUseCase(event.bookingId);
    result.fold(
      (failure) => emit(BookingError(message: failure.message)),
      (booking) => emit(BookingLoaded(booking: booking)),
    );
  }

  Future<void> _onBookingCreateRequested(
    BookingCreateRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    final request = BookingRequest(
      eventId: event.eventId,
      ticketTypeId: event.ticketTypeId,
      quantity: event.quantity,
      promoCode: event.promoCode,
    );
    final result = await _createBookingUseCase(request);
    result.fold(
      (failure) => emit(BookingError(message: failure.message)),
      (confirmation) => emit(BookingCreated(confirmation: confirmation)),
    );
  }

  Future<void> _onBookingCancelRequested(
    BookingCancelRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    final result = await _cancelBookingUseCase(event.bookingId, event.reason);
    result.fold(
      (failure) => emit(BookingError(message: failure.message)),
      (_) => emit(const BookingCancelled()),
    );
  }

  Future<void> _onBookingQRCodeRequested(
    BookingQRCodeRequested event,
    Emitter<BookingState> emit,
  ) async {
    final result = await _getBookingQRCodeUseCase(event.bookingId);
    result.fold(
      (failure) => emit(BookingError(message: failure.message)),
      (qrCodeUrl) => emit(BookingQRCodeLoaded(qrCodeUrl: qrCodeUrl)),
    );
  }
}