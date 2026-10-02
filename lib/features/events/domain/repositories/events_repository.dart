import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import 'event.dart';

abstract class EventsRepository {
  Future<Either<Failure, List<Event>>> getEvents({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
    bool? featured,
    DateTime? startDate,
    DateTime? endDate,
  });
  
  Future<Either<Failure, Event>> getEventById(String id);
  
  Future<Either<Failure, List<Event>>> getFeaturedEvents({int limit = 10});
  
  Future<Either<Failure, List<EventCategory>>> getCategories();
  
  Future<Either<Failure, List<Event>>> searchEvents(String query, {int page = 1, int limit = 20});
  
  Future<Either<Failure, List<Event>>> getEventsByCategory(String categoryId, {int page = 1, int limit = 20});
}