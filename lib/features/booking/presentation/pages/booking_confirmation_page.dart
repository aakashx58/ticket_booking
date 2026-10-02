import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/booking.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';

class BookingConfirmationPage extends StatefulWidget {
  final String bookingId;

  const BookingConfirmationPage({super.key, required this.bookingId});

  @override
  State<BookingConfirmationPage> createState() => _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage> {
  String? _qrCodeUrl;

  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(BookingLoadRequested(bookingId: widget.bookingId));
    context.read<BookingBloc>().add(BookingQRCodeRequested(bookingId: widget.bookingId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmed'),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingQRCodeLoaded) {
            setState(() => _qrCodeUrl = state.qrCodeUrl);
          }
        },
        child: BlocBuilder<BookingBloc, BookingState>(
          buildWhen: (previous, current) => current is BookingLoaded || current is BookingLoading || current is BookingError,
          builder: (context, state) {
            if (state is BookingLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is BookingError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<BookingBloc>().add(BookingLoadRequested(bookingId: widget.bookingId)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            if (state is BookingLoaded) {
              return _buildConfirmation(state.booking);
            }
            
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildConfirmation(Booking booking) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSuccessHeader(),
          const SizedBox(height: 24),
          _buildConfirmationCode(booking),
          const SizedBox(height: 24),
          _buildEventDetails(booking),
          const SizedBox(height: 24),
          _buildTicketDetails(booking),
          const SizedBox(height: 24),
          if (_qrCodeUrl != null) _buildQRCode(booking),
          const SizedBox(height: 24),
          _buildActionButtons(booking),
        ],
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle, color: Colors.green, size: 50),
        ),
        const SizedBox(height: 16),
        Text(
          'Booking Confirmed!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Your tickets have been successfully booked.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildConfirmationCode(Booking booking) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Confirmation Code',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: 8),
            Text(
              booking.confirmationCode ?? 'N/A',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Booked on ${DateFormat('MMM d, yyyy • h:mm a').format(booking.bookedAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetails(Booking booking) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Event Details', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.event_outlined, 'Event', booking.eventTitle),
            _buildDetailRow(Icons.calendar_today_outlined, 'Date & Time', DateFormat('EEEE, MMM d, yyyy • h:mm a').format(booking.eventDate)),
            _buildDetailRow(Icons.location_on_outlined, 'Venue', '${booking.venueName}, ${booking.venueAddress}'),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketDetails(Booking booking) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ticket Details', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.confirmation_number_outlined, 'Ticket Type', booking.ticketTypeName),
            _buildDetailRow(Icons.format_list_numbered_outlined, 'Quantity', '${booking.quantity}'),
            _buildDetailRow(Icons.attach_money_outlined, 'Unit Price', '\$${booking.unitPrice.toStringAsFixed(2)}'),
            _buildDetailRow(Icons.receipt_long_outlined, 'Total Paid', '\$${booking.totalPrice.toStringAsFixed(2)}'),
            const Divider(),
            _buildDetailRow(Icons.money_off_outlined, 'Fees', '\$${booking.fees.toStringAsFixed(2)}'),
            _buildDetailRow(Icons.account_balance_wallet_outlined, 'Taxes', '\$${booking.taxes.toStringAsFixed(2)}'),
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
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

  Widget _buildQRCode(Booking booking) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('QR Code', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                ),
                child: _qrCodeUrl != null
                    ? Image.network(
                        _qrCodeUrl!,
                        width: 200,
                        height: 200,
                        errorBuilder: (_, __, ___) => const Icon(Icons.qr_code, size: 100),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Show this QR code at the venue entrance',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(Booking booking) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Confirmation code ${booking.confirmationCode} copied to clipboard')),
              );
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy Confirmation Code'),
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.go('/bookings'),
            icon: const Icon(Icons.list_alt),
            label: const Text('View All Bookings'),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () => context.go('/events'),
            icon: const Icon(Icons.explore),
            label: const Text('Explore More Events'),
          ),
        ),
      ],
    );
  }
}