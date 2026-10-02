part of 'events_bloc.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object?> get props => [];
}

class EventsLoadRequested extends EventsEvent {
  final int page;
  final String? category;
  final String? search;
  final bool? featured;
  final bool loadMore;

  const EventsLoadRequested({
    this.page = 1,
    this.category,
    this.search,
    this.featured,
    this.loadMore = false,
  });

  @override
  List<Object?> get props => [page, category, search, featured, loadMore];
}

class EventsRefreshRequested extends EventsEvent {
  const EventsRefreshRequested();
}

class EventLoadRequested extends EventsEvent {
  final String eventId;

  const EventLoadRequested({required this.eventId});

  @override
  List<Object> get props => [eventId];
}

class FeaturedEventsLoadRequested extends EventsEvent {
  final int limit;

  const FeaturedEventsLoadRequested({this.limit = 10});

  @override
  List<Object> get props => [limit];
}

class CategoriesLoadRequested extends EventsEvent {
  const CategoriesLoadRequested();
}

class EventsSearchRequested extends EventsEvent {
  final String query;
  final int page;

  const EventsSearchRequested({required this.query, this.page = 1});

  @override
  List<Object> get props => [query, page];
}

class EventsFilterByCategoryRequested extends EventsEvent {
  final String categoryId;
  final int page;

  const EventsFilterByCategoryRequested({required this.categoryId, this.page = 1});

  @override
  List<Object> get props => [categoryId, page];
}