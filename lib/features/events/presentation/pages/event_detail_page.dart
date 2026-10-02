import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/event.dart';
import '../bloc/events_bloc.dart';
import '../bloc/events_event.dart';
import '../bloc/events_state.dart';

class EventDetailPage extends StatefulWidget {
  final String eventId;

  const EventDetailPage({super.key, required this.eventId});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<EventsBloc>().add(EventLoadRequested(eventId: widget.eventId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EventsBloc, EventsState>(
        buildWhen: (previous, current) => current is EventLoaded || current is EventsLoading || current is EventsError,
        builder: (context, state) {
          if (state is EventsLoading) {
            return _buildLoadingState();
          }
          
          if (state is EventsError) {
            return _buildErrorState(state.message);
          }
          
          if (state is EventLoaded) {
            return _buildEventDetail(state.event);
          }
          
          return _buildLoadingState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 250,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildShimmerContainer(height: 24, width: double.infinity),
                const SizedBox(height: 16),
                _buildShimmerContainer(height: 16, width: 200),
                const SizedBox(height: 24),
                _buildShimmerContainer(height: 100, width: double.infinity),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerContainer({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<EventsBloc>().add(EventLoadRequested(eventId: widget.eventId)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetail(Event event) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (event.bannerUrl != null)
                  CachedNetworkImage(
                    imageUrl: event.bannerUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.event, size: 64),
                    ),
                  )
                else
                  Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: const Center(child: Icon(Icons.event, size: 64)),
                  ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: Colors.white.withOpacity(0.9), size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${event.venueName}, ${event.venueAddress}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, color: Colors.white.withOpacity(0.9), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            _formatDateRange(event.startDate, event.endDate),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoChips(event),
                const SizedBox(height: 24),
                _buildSectionTitle('Description'),
                const SizedBox(height: 8),
                Text(
                  event.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Venue Details'),
                const SizedBox(height: 8),
                _buildVenueDetails(event),
                const SizedBox(height: 24),
                _buildSectionTitle('Available Tickets'),
                const SizedBox(height: 8),
                _buildTicketTypes(event),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
      bottomNavigationBar: _buildBottomBar(event),
    );
  }

  Widget _buildInfoChips(Event event) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (event.isFeatured)
          Chip(
            label: const Text('Featured'),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        if (event.isSoldOut)
          Chip(
            label: const Text('Sold Out'),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
          ),
        Chip(
          label: Text(event.category),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
        ),
        Chip(
          label: Text('${event.availableTickets} tickets left'),
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildVenueDetails(Event event) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDetailRow(Icons.location_on_outlined, 'Venue', event.venueName),
            _buildDetailRow(Icons.place_outlined, 'Address', event.venueAddress),
            if (event.venueCity != null)
              _buildDetailRow(Icons.location_city_outlined, 'City', event.venueCity!),
            if (event.venueCountry != null)
              _buildDetailRow(Icons.public_outlined, 'Country', event.venueCountry!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketTypes(Event event) {
    if (event.ticketTypes.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'No ticket types available',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Column(
      children: event.ticketTypes.map((ticket) => _buildTicketCard(ticket)).toList(),
    );
  }

  Widget _buildTicketCard(TicketType ticket) {
    final isAvailable = ticket.isAvailable && ticket.available > 0;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (ticket.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      ticket.description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${ticket.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${ticket.available} available',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isAvailable 
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isAvailable)
              ElevatedButton(
                onPressed: () => context.push('/booking/${widget.eventId}?ticketId=${ticket.id}'),
                child: const Text('Book Now'),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ticket.isActive ? 'Sold Out' : 'Sales Ended',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(Event event) {
    final hasAvailableTickets = event.ticketTypes.any((t) => t.isAvailable && t.available > 0);
    
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Starting from',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '\$${event.ticketTypes.isNotEmpty ? event.ticketTypes.map((t) => t.price).reduce((a, b) => a < b ? a : b).toStringAsFixed(2) : '0.00'}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: hasAvailableTickets
                  ? () => context.push('/booking/${event.id}')
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(hasAvailableTickets ? 'Book Tickets' : 'Sold Out'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateRange(DateTime start, DateTime end) {
    final formatter = DateFormat('MMM d, yyyy • h:mm a');
    if (start.day == end.day && start.month == end.month && start.year == end.year) {
      return '${formatter.format(start)} - ${DateFormat('h:mm a').format(end)}';
    }
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }
}