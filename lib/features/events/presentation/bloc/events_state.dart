part of 'events_bloc.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object?> get props => [];
}

class EventsInitial extends EventsState {
  const EventsInitial();
}

class EventsLoading extends EventsState {
  final bool isLoadMore;

  const EventsLoading({this.isLoadMore = false});

  @override
  List<Object> get props => [isLoadMore];
}

class EventsLoaded extends EventsState {
  final List<Event> events;
  final bool hasReachedMax;
  final int currentPage;
  final String? category;
  final String? search;

  const EventsLoaded({
    required this.events,
    required this.hasReachedMax,
    required this.currentPage,
    this.category,
    this.search,
  });

  @override
  List<Object?> get props => [events, hasReachedMax, currentPage, category, search];
}

class EventLoaded extends EventsState {
  final Event event;

  const EventLoaded({required this.event});

  @override
  List<Object> get props => [event];
}

class FeaturedEventsLoaded extends EventsState {
  final List<Event> events;

  const FeaturedEventsLoaded({required this.events});

  @override
  List<Object> get props => [events];
}

class CategoriesLoaded extends EventsState {
  final List<EventCategory> categories;

  const CategoriesLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

class EventsError extends EventsState {
  final String message;

  const EventsError({required this.message});

  @override
  List<Object> get props => [message];
}