import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() {
    return _BookingScreenState();
  }
}

class _BookingScreenState extends State<BookingsScreen> {
  List<BookingRecord> _bookings = [];
  bool _loading = true;
  String _errorMsg = '';

  @override
  Widget build(BuildContext context) {
    final Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_errorMsg.isNotEmpty) {
      body = Center(child: Text(_errorMsg));
    } else if (_bookings.isEmpty) {
      body = const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 31.0),
          child: Text('No bookings here.',
              style: TextStyle(fontSize: 17, color: Colors.grey)),
        ),
      );
    } else {
      body = ListView.builder(
        itemCount: _bookings.length,
        itemBuilder: (BuildContext context, int idx) {
          return _buildBookingCard(_bookings[idx]);
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: cinemaHeaderStyle),
      ),
      body: body,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final List<BookingRecord> bookings =
          await CinemaDatabase.instance.getAllOrders();
      if (!mounted) {
        return;
      }
      setState(() {
        _bookings = bookings;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMsg = 'Could not load bookings: $error';
        _loading = false;
      });
    }
  }

  Widget _buildBookingCard(BookingRecord booking) {
    return Card(
      color: cinemaSurface,
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 9.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking #${booking.bookingNumber}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('£${booking.total.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 4),
            Text(booking.summary,
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              booking.date,
              style: const TextStyle(fontSize: 13, color: cinemaFontWhite),
            ),
          ],
        ),
      ),
    );
  }
}
