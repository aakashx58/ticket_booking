import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/event.dart';
import '../../domain/usecases/events_usecases.dart';
import 'events_event.dart';
import 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GetEventsUseCase _getEventsUseCase;
  final GetEventByIdUseCase _getEventByIdUseCase;
  final GetFeaturedEventsUseCase _getFeaturedEventsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final SearchEventsUseCase _searchEventsUseCase;
  final GetEventsByCategoryUseCase _getEventsByCategoryUseCase;

  EventsBloc({
    required GetEventsUseCase getEventsUseCase,
    required GetEventByIdUseCase getEventByIdUseCase,
    required GetFeaturedEventsUseCase getFeaturedEventsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required SearchEventsUseCase searchEventsUseCase,
    required GetEventsByCategoryUseCase getEventsByCategoryUseCase,
  })  : _getEventsUseCase = getEventsUseCase,
        _getEventByIdUseCase = getEventByIdUseCase,
        _getFeaturedEventsUseCase = getFeaturedEventsUseCase,
        _getCategoriesUseCase = getCategoriesUseCase,
        _searchEventsUseCase = searchEventsUseCase,
        _getEventsByCategoryUseCase = getEventsByCategoryUseCase,
        super(const EventsInitial()) {
    on<EventsLoadRequested>(_onEventsLoadRequested);
    on<EventsRefreshRequested>(_onEventsRefreshRequested);
    on<EventLoadRequested>(_onEventLoadRequested);
    on<FeaturedEventsLoadRequested>(_onFeaturedEventsLoadRequested);
    on<CategoriesLoadRequested>(_onCategoriesLoadRequested);
    on<EventsSearchRequested>(_onEventsSearchRequested);
    on<EventsFilterByCategoryRequested>(_onEventsFilterByCategoryRequested);
  }

  Future<void> _onEventsLoadRequested(
    EventsLoadRequested event,
    Emitter<EventsState> emit,
  ) async {
    if (event.loadMore) {
      final currentState = state;
      if (currentState is EventsLoaded && currentState.hasReachedMax) return;
      emit(EventsLoading(isLoadMore: true));
    } else {
      emit(const EventsLoading());
    }

    final result = await _getEventsUseCase(
      page: event.page,
      category: event.category,
      search: event.search,
      featured: event.featured,
    );

    result.fold(
      (failure) => emit(EventsError(message: failure.message)),
      (events) {
        final currentState = state;
        if (event.loadMore && currentState is EventsLoaded) {
          final allEvents = [...currentState.events, ...events];
          emit(EventsLoaded(
            events: allEvents,
            hasReachedMax: events.length < 20,
            currentPage: event.page,
            category: event.category,
            search: event.search,
          ));
        } else {
          emit(EventsLoaded(
            events: events,
            hasReachedMax: events.length < 20,
            currentPage: event.page,
            category: event.category,
            search: event.search,
          ));
        }
      },
    );
  }

  Future<void> _onEventsRefreshRequested(
    EventsRefreshRequested event,
    Emitter<EventsState> emit,
  ) async {
    final currentState = state;
    String? category;
    String? search;
    
    if (currentState is EventsLoaded) {
      category = currentState.category;
      search = currentState.search;
    }

    final result = await _getEventsUseCase(
      page: 1,
      category: category,
      search: search,
    );

    result.fold(
      (failure) => emit(EventsError(message: failure.message)),
      (events) => emit(EventsLoaded(
        events: events,
        hasReachedMax: events.length < 20,
        currentPage: 1,
        category: category,
        search: search,
      )),
    );
  }

  Future<void> _onEventLoadRequested(
    EventLoadRequested event,
    Emitter<EventsState> emit,
  ) async {
    emit(const EventsLoading());
    final result = await _getEventByIdUseCase(event.eventId);
    result.fold(
      (failure) => emit(EventsError(message: failure.message)),
      (event) => emit(EventLoaded(event: event)),
    );
  }

  Future<void> _onFeaturedEventsLoadRequested(
    FeaturedEventsLoadRequested event,
    Emitter<EventsState> emit,
  ) async {
    final result = await _getFeaturedEventsUseCase(limit: event.limit);
    result.fold(
      (failure) => emit(EventsError(message: failure.message)),
      (events) => emit(FeaturedEventsLoaded(events: events)),
    );
  }

  Future<void> _onCategoriesLoadRequested(
    CategoriesLoadRequested event,
    Emitter<EventsState> emit,
  ) async {
    final result = await _getCategoriesUseCase();
    result.fold(
      (failure) => emit(EventsError(message: failure.message)),
      (categories) => emit(CategoriesLoaded(categories: categories)),
    );
  }

  Future<void> _onEventsSearchRequested(
    EventsSearchRequested event,
    Emitter<EventsState> emit,
  ) async {
    if (event.page == 1) {
      emit(const EventsLoading());
    } else {
      final currentState = state;
      if (currentState is EventsLoaded && currentState.hasReachedMax) return;
      emit(EventsLoading(isLoadMore: true));
    }

    final result = await _searchEventsUseCase(event.query, page: event.page);
    result.fold(
      (failure) => emit(EventsError(message: failure.message)),
      (events) {
        final currentState = state;
        if (event.page > 1 && currentState is EventsLoaded) {
          final allEvents = [...currentState.events, ...events];
          emit(EventsLoaded(
            events: allEvents,
            hasReachedMax: events.length < 20,
            currentPage: event.page,
            search: event.query,
          ));
        } else {
          emit(EventsLoaded(
            events: events,
            hasReachedMax: events.length < 20,
            currentPage: event.page,
            search: event.query,
          ));
        }
      },
    );
  }

  Future<void> _onEventsFilterByCategoryRequested(
    EventsFilterByCategoryRequested event,
    Emitter<EventsState> emit,
  ) async {
    if (event.page == 1) {
      emit(const EventsLoading());
    } else {
      final currentState = state;
      if (currentState is EventsLoaded && currentState.hasReachedMax) return;
      emit(EventsLoading(isLoadMore: true));
    }

    final result = await _getEventsByCategoryUseCase(event.categoryId, page: event.page);
    result.fold(
      (failure) => emit(EventsError(message: failure.message)),
      (events) {
        final currentState = state;
        if (event.page > 1 && currentState is EventsLoaded) {
          final allEvents = [...currentState.events, ...events];
          emit(EventsLoaded(
            events: allEvents,
            hasReachedMax: events.length < 20,
            currentPage: event.page,
            category: event.categoryId,
          ));
        } else {
          emit(EventsLoaded(
            events: events,
            hasReachedMax: events.length < 20,
            currentPage: event.page,
            category: event.categoryId,
          ));
        }
      },
    );
  }
}