import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? shortDescription;
  final String? imageUrl;
  final String? bannerUrl;
  final DateTime startDate;
  final DateTime endDate;
  final String venueName;
  final String venueAddress;
  final String? venueCity;
  final String? venueCountry;
  final double latitude;
  final double longitude;
  final List<TicketType> ticketTypes;
  final String category;
  final List<String> tags;
  final bool isFeatured;
  final bool isSoldOut;
  final int totalTickets;
  final int soldTickets;
  final double rating;
  final int reviewCount;
  final String organizerId;
  final String? organizerName;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    this.shortDescription,
    this.imageUrl,
    this.bannerUrl,
    required this.startDate,
    required this.endDate,
    required this.venueName,
    required this.venueAddress,
    this.venueCity,
    this.venueCountry,
    required this.latitude,
    required this.longitude,
    required this.ticketTypes,
    required this.category,
    required this.tags,
    required this.isFeatured,
    required this.isSoldOut,
    required this.totalTickets,
    required this.soldTickets,
    required this.rating,
    required this.reviewCount,
    required this.organizerId,
    this.organizerName,
    required this.createdAt,
    required this.updatedAt,
  });

  int get availableTickets => totalTickets - soldTickets;
  
  double get salesPercentage => totalTickets > 0 ? (soldTickets / totalTickets) * 100 : 0;
  
  bool get isUpcoming => startDate.isAfter(DateTime.now());
  
  bool get isOngoing => startDate.isBefore(DateTime.now()) && endDate.isAfter(DateTime.now());
  
  bool get hasEnded => endDate.isBefore(DateTime.now());

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    shortDescription,
    imageUrl,
    bannerUrl,
    startDate,
    endDate,
    venueName,
    venueAddress,
    venueCity,
    venueCountry,
    latitude,
    longitude,
    ticketTypes,
    category,
    tags,
    isFeatured,
    isSoldOut,
    totalTickets,
    soldTickets,
    rating,
    reviewCount,
    organizerId,
    organizerName,
    createdAt,
    updatedAt,
  ];

  Event copyWith({
    String? id,
    String? title,
    String? description,
    String? shortDescription,
    String? imageUrl,
    String? bannerUrl,
    DateTime? startDate,
    DateTime? endDate,
    String? venueName,
    String? venueAddress,
    String? venueCity,
    String? venueCountry,
    double? latitude,
    double? longitude,
    List<TicketType>? ticketTypes,
    String? category,
    List<String>? tags,
    bool? isFeatured,
    bool? isSoldOut,
    int? totalTickets,
    int? soldTickets,
    double? rating,
    int? reviewCount,
    String? organizerId,
    String? organizerName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      imageUrl: imageUrl ?? this.imageUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      venueName: venueName ?? this.venueName,
      venueAddress: venueAddress ?? this.venueAddress,
      venueCity: venueCity ?? this.venueCity,
      venueCountry: venueCountry ?? this.venueCountry,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      ticketTypes: ticketTypes ?? this.ticketTypes,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isFeatured: isFeatured ?? this.isFeatured,
      isSoldOut: isSoldOut ?? this.isSoldOut,
      totalTickets: totalTickets ?? this.totalTickets,
      soldTickets: soldTickets ?? this.soldTickets,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class TicketType extends Equatable {
  final String id;
  final String eventId;
  final String name;
  final String? description;
  final double price;
  final int quantity;
  final int sold;
  final int maxPerOrder;
  final DateTime salesStart;
  final DateTime salesEnd;
  final bool isActive;

  const TicketType({
    required this.id,
    required this.eventId,
    required this.name,
    this.description,
    required this.price,
    required this.quantity,
    required this.sold,
    required this.maxPerOrder,
    required this.salesStart,
    required this.salesEnd,
    required this.isActive,
  });

  int get available => quantity - sold;
  bool get isAvailable => isActive && available > 0 && DateTime.now().isAfter(salesStart) && DateTime.now().isBefore(salesEnd);

  @override
  List<Object?> get props => [
    id,
    eventId,
    name,
    description,
    price,
    quantity,
    sold,
    maxPerOrder,
    salesStart,
    salesEnd,
    isActive,
  ];
}

class EventCategory extends Equatable {
  final String id;
  final String name;
  final String? icon;
  final int eventCount;

  const EventCategory({
    required this.id,
    required this.name,
    this.icon,
    required this.eventCount,
  });

  @override
  List<Object?> get props => [id, name, icon, eventCount];
}