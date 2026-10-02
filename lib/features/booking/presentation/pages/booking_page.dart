import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/booking.dart';
import '../../events/domain/entities/event.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../../events/presentation/bloc/events_bloc.dart';
import '../../events/presentation/bloc/events_event.dart';
import '../../events/presentation/bloc/events_state.dart';

class BookingPage extends StatefulWidget {
  final String eventId;

  const BookingPage({super.key, required this.eventId});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? _selectedTicketTypeId;
  int _quantity = 1;
  String? _promoCode;
  final _promoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<EventsBloc>().add(EventLoadRequested(eventId: widget.eventId));
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Tickets'),
      ),
      body: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingCreated) {
            context.go('/booking/confirmation/${state.confirmation.bookingId}');
          } else if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<EventsBloc, EventsState>(
          buildWhen: (previous, current) => current is EventLoaded || current is EventsLoading || current is EventsError,
          builder: (context, state) {
            if (state is EventsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is EventsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<EventsBloc>().add(EventLoadRequested(eventId: widget.eventId)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            if (state is EventLoaded) {
              return _buildBookingForm(state.event);
            }
            
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildBookingForm(Event event) {
    final availableTicketTypes = event.ticketTypes.where((t) => t.isAvailable && t.available > 0).toList();
    
    if (availableTicketTypes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sentiment_dissatisfied, size: 64),
            const SizedBox(height: 16),
            const Text('No tickets available for this event'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Back to Events'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEventSummary(event),
          const SizedBox(height: 24),
          _buildTicketSelection(availableTicketTypes),
          const SizedBox(height: 24),
          _buildQuantitySelector(),
          const SizedBox(height: 24),
          _buildPromoCode(),
          const SizedBox(height: 24),
          _buildPriceBreakdown(event, availableTicketTypes),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildEventSummary(Event event) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: event.imageUrl != null
                    ? Image.network(event.imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.event))
                    : const Icon(Icons.event, size: 40),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM d, yyyy • h:mm a').format(event.startDate),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.venueName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
    );
  }

  Widget _buildTicketSelection(List<TicketType> ticketTypes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Ticket Type', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...ticketTypes.map((ticket) => _buildTicketOption(ticket)).toList(),
      ],
    );
  }

  Widget _buildTicketOption(TicketType ticket) {
    final isSelected = _selectedTicketTypeId == ticket.id;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedTicketTypeId = ticket.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          ticket.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 20),
                        ],
                      ],
                    ),
                    if (ticket.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        ticket.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${ticket.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${ticket.available} left',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onTertiaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Radio<String>(
                value: ticket.id,
                groupValue: _selectedTicketTypeId,
                onChanged: (value) => setState(() => _selectedTicketTypeId = value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quantity', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            IconButton(
              onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
              icon: const Icon(Icons.remove_circle_outline),
              iconSize: 28,
            ),
            const SizedBox(width: 16),
            Text(
              '$_quantity',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: _selectedTicketTypeId != null 
                  ? () {
                      final ticket = context.read<EventsBloc>().state;
                      if (ticket is EventLoaded) {
                        final selectedTicket = ticket.event.ticketTypes.firstWhere((t) => t.id == _selectedTicketTypeId);
                        if (_quantity < selectedTicket.available && _quantity < selectedTicket.maxPerOrder) {
                          setState(() => _quantity++);
                        }
                      }
                    }
                  : null,
              icon: const Icon(Icons.add_circle_outline),
              iconSize: 28,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPromoCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Promo Code (Optional)', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextField(
          controller: _promoController,
          decoration: InputDecoration(
            hintText: 'Enter promo code',
            prefixIcon: const Icon(Icons.local_offer_outlined),
            suffixIcon: _promoCode != null
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _promoCode = null;
                        _promoController.clear();
                      });
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      if (_promoController.text.isNotEmpty) {
                        setState(() => _promoCode = _promoController.text.trim());
                      }
                    },
                  ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceBreakdown(Event event, List<TicketType> ticketTypes) {
    final selectedTicket = ticketTypes.firstWhere(
      (t) => t.id == _selectedTicketTypeId,
      orElse: () => ticketTypes.first,
    );
    
    final subtotal = selectedTicket.price * _quantity;
    final fees = subtotal * 0.1;
    final taxes = subtotal * 0.05;
    final total = subtotal + fees + taxes;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price Details', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildPriceRow('${_quantity}x ${selectedTicket.name}', '\$${subtotal.toStringAsFixed(2)}'),
            _buildPriceRow('Service Fee', '\$${fees.toStringAsFixed(2)}'),
            _buildPriceRow('Taxes', '\$${taxes.toStringAsFixed(2)}'),
            const Divider(),
            _buildPriceRow('Total', '\$${total.toStringAsFixed(2)}', isTotal: true),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _selectedTicketTypeId != null
                    ? () {
                        context.read<BookingBloc>().add(BookingCreateRequested(
                          eventId: widget.eventId,
                          ticketTypeId: _selectedTicketTypeId!,
                          quantity: _quantity,
                          promoCode: _promoCode,
                        ));
                      }
                    : null,
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text('Pay \$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}