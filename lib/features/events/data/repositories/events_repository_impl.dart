import 'package:dartz/dartz.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/events_repository.dart';
import '../../core/errors/failures.dart';
import '../datasources/events_remote_data_source.dart';
import '../models/event_model.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDataSource _remoteDataSource;

  EventsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Event>>> getEvents({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
    bool? featured,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final result = await _remoteDataSource.getEvents(
      page: page,
      limit: limit,
      category: category,
      search: search,
      featured: featured,
      startDate: startDate,
      endDate: endDate,
    );
    
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((m) => m.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, Event>> getEventById(String id) async {
    final result = await _remoteDataSource.getEventById(id);
    
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, List<Event>>> getFeaturedEvents({int limit = 10}) async {
    final result = await _remoteDataSource.getFeaturedEvents(limit: limit);
    
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((m) => m.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, List<EventCategory>>> getCategories() async {
    final result = await _remoteDataSource.getCategories();
    
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((m) => m.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, List<Event>>> searchEvents(String query, {int page = 1, int limit = 20}) async {
    final result = await _remoteDataSource.searchEvents(query, page: page, limit: limit);
    
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((m) => m.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, List<Event>>> getEventsByCategory(String categoryId, {int page = 1, int limit = 20}) async {
    final result = await _remoteDataSource.getEventsByCategory(categoryId, page: page, limit: limit);
    
    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((m) => m.toEntity()).toList()),
    );
  }
}