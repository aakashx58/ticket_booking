import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/event.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    required String title,
    required String description,
    String? shortDescription,
    String? imageUrl,
    String? bannerUrl,
    required DateTime startDate,
    required DateTime endDate,
    required String venueName,
    required String venueAddress,
    String? venueCity,
    String? venueCountry,
    required double latitude,
    required double longitude,
    required List<TicketTypeModel> ticketTypes,
    required String category,
    required List<String> tags,
    required bool isFeatured,
    required bool isSoldOut,
    required int totalTickets,
    required int soldTickets,
    required double rating,
    required int reviewCount,
    required String organizerId,
    String? organizerName,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) => _$EventModelFromJson(json);
}

@freezed
class TicketTypeModel with _$TicketTypeModel {
  const factory TicketTypeModel({
    required String id,
    required String eventId,
    required String name,
    String? description,
    required double price,
    required int quantity,
    required int sold,
    required int maxPerOrder,
    required DateTime salesStart,
    required DateTime salesEnd,
    required bool isActive,
  }) = _TicketTypeModel;

  factory TicketTypeModel.fromJson(Map<String, dynamic> json) => _$TicketTypeModelFromJson(json);
}

@freezed
class EventCategoryModel with _$EventCategoryModel {
  const factory EventCategoryModel({
    required String id,
    required String name,
    String? icon,
    required int eventCount,
  }) = _EventCategoryModel;

  factory EventCategoryModel.fromJson(Map<String, dynamic> json) => _$EventCategoryModelFromJson(json);
}

extension EventModelX on EventModel {
  Event toEntity() {
    return Event(
      id: id,
      title: title,
      description: description,
      shortDescription: shortDescription,
      imageUrl: imageUrl,
      bannerUrl: bannerUrl,
      startDate: startDate,
      endDate: endDate,
      venueName: venueName,
      venueAddress: venueAddress,
      venueCity: venueCity,
      venueCountry: venueCountry,
      latitude: latitude,
      longitude: longitude,
      ticketTypes: ticketTypes.map((e) => e.toEntity()).toList(),
      category: category,
      tags: tags,
      isFeatured: isFeatured,
      isSoldOut: isSoldOut,
      totalTickets: totalTickets,
      soldTickets: soldTickets,
      rating: rating,
      reviewCount: reviewCount,
      organizerId: organizerId,
      organizerName: organizerName,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension TicketTypeModelX on TicketTypeModel {
  TicketType toEntity() {
    return TicketType(
      id: id,
      eventId: eventId,
      name: name,
      description: description,
      price: price,
      quantity: quantity,
      sold: sold,
      maxPerOrder: maxPerOrder,
      salesStart: salesStart,
      salesEnd: salesEnd,
      isActive: isActive,
    );
  }
}

extension EventCategoryModelX on EventCategoryModel {
  EventCategory toEntity() {
    return EventCategory(
      id: id,
      name: name,
      icon: icon,
      eventCount: eventCount,
    );
  }
}