import 'package:dartz/dartz.dart';
import '../entities/event.dart';
import '../repositories/events_repository.dart';
import '../../core/errors/failures.dart';

class GetEventsUseCase {
  final EventsRepository repository;

  GetEventsUseCase(this.repository);

  Future<Either<Failure, List<Event>>> call({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
    bool? featured,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return repository.getEvents(
      page: page,
      limit: limit,
      category: category,
      search: search,
      featured: featured,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

class GetEventByIdUseCase {
  final EventsRepository repository;

  GetEventByIdUseCase(this.repository);

  Future<Either<Failure, Event>> call(String id) {
    return repository.getEventById(id);
  }
}

class GetFeaturedEventsUseCase {
  final EventsRepository repository;

  GetFeaturedEventsUseCase(this.repository);

  Future<Either<Failure, List<Event>>> call({int limit = 10}) {
    return repository.getFeaturedEvents(limit: limit);
  }
}

class GetCategoriesUseCase {
  final EventsRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<Either<Failure, List<EventCategory>>> call() {
    return repository.getCategories();
  }
}

class SearchEventsUseCase {
  final EventsRepository repository;

  SearchEventsUseCase(this.repository);

  Future<Either<Failure, List<Event>>> call(String query, {int page = 1, int limit = 20}) {
    return repository.searchEvents(query, page: page, limit: limit);
  }
}

class GetEventsByCategoryUseCase {
  final EventsRepository repository;

  GetEventsByCategoryUseCase(this.repository);

  Future<Either<Failure, List<Event>>> call(String categoryId, {int page = 1, int limit = 20}) {
    return repository.getEventsByCategory(categoryId, page: page, limit: limit);
  }
}