import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/network/api_service.dart';
import '../models/event_model.dart';

abstract class EventsRemoteDataSource {
  Future<Either<Failure, List<EventModel>>> getEvents({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
    bool? featured,
    DateTime? startDate,
    DateTime? endDate,
  });
  
  Future<Either<Failure, EventModel>> getEventById(String id);
  
  Future<Either<Failure, List<EventModel>>> getFeaturedEvents({int limit = 10});
  
  Future<Either<Failure, List<EventCategoryModel>>> getCategories();
  
  Future<Either<Failure, List<EventModel>>> searchEvents(String query, {int page = 1, int limit = 20});
  
  Future<Either<Failure, List<EventModel>>> getEventsByCategory(String categoryId, {int page = 1, int limit = 20});
}

class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  final ApiService _apiService;

  EventsRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, List<EventModel>>> getEvents({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
    bool? featured,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      
      if (category != null) queryParams['category'] = category;
      if (search != null) queryParams['search'] = search;
      if (featured != null) queryParams['featured'] = featured;
      if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();

      final response = await _apiService.get('/events', queryParameters: queryParams);
      final data = response.data['data'] as List;
      return Right(data.map((e) => EventModel.fromJson(e)).toList());
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventModel>> getEventById(String id) async {
    try {
      final response = await _apiService.get('/events/$id');
      return Right(EventModel.fromJson(response.data['data']));
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventModel>>> getFeaturedEvents({int limit = 10}) async {
    try {
      final response = await _apiService.get('/events/featured', queryParameters: {'limit': limit});
      final data = response.data['data'] as List;
      return Right(data.map((e) => EventModel.fromJson(e)).toList());
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventCategoryModel>>> getCategories() async {
    try {
      final response = await _apiService.get('/events/categories');
      final data = response.data['data'] as List;
      return Right(data.map((e) => EventCategoryModel.fromJson(e)).toList());
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventModel>>> searchEvents(String query, {int page = 1, int limit = 20}) async {
    try {
      final response = await _apiService.get('/events/search', queryParameters: {
        'q': query,
        'page': page,
        'limit': limit,
      });
      final data = response.data['data'] as List;
      return Right(data.map((e) => EventModel.fromJson(e)).toList());
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventModel>>> getEventsByCategory(String categoryId, {int page = 1, int limit = 20}) async {
    try {
      final response = await _apiService.get('/events/category/$categoryId', queryParameters: {
        'page': page,
        'limit': limit,
      });
      final data = response.data['data'] as List;
      return Right(data.map((e) => EventModel.fromJson(e)).toList());
    } catch (e) {
      return Left(e is Failure ? e : Failure(message: e.toString()));
    }
  }
}