import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/widgets/main_button.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/order_item.dart';
import 'package:southsea_cinema/database/cinema_db.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() {
    return _BasketScreenState();
  }
}

class _BasketScreenState extends State<BasketScreen> {
  String _finalmessage = '';
  List<BookingRecord> _pastBookings = [];
  Map<int, List<OrderItem>> _pastItemsByBooking = <int, List<OrderItem>>{};
  bool _loadingPastOrders = true;
  String _pastOrdersError = '';

  @override
  void initState() {
    super.initState();
    _loadPastOrders();
  }

  String _buildSummary(List<BasketItem> movies) {
    final List<String> parts = [];
    for (final BasketItem movie in movies) {
      parts.add('${movie.quantity}x ${movie.movie.name}');
    }
    return parts.join(', ');
  }

  String _formatDate(DateTime now) {
    final String day = now.day.toString().padLeft(2, '0');
    final String month = now.month.toString().padLeft(2, '0');
    final String hour = now.hour.toString().padLeft(2, '0');
    final String minute = now.minute.toString().padLeft(2, '0');
    return '$day/$month/${now.year} $hour:$minute';
  }

  Future<void> _checkout(
      BasketRepository basket, List<BasketItem> movies) async {
    final String summary = _buildSummary(movies);
    final double total = basket.getAmountDue();
    final String date = _formatDate(DateTime.now());

    try {
      final CinemaDatabase database = CinemaDatabase.instance;
      final int bookingNumber = await database.getNextBookingNumber();
      final BookingRecord record = BookingRecord(
          bookingNumber: bookingNumber,
          summary: summary,
          total: total,
          date: date);

      final List<OrderItem> items = movies
          .map(
            (BasketItem item) => OrderItem(
              movieName: item.movie.name,
              showingDateTime: item.movie.showingDateTime,
              quantity: item.quantity,
              unitPrice: item.movie.price,
              lineTotal: item.movieTotal,
            ),
          )
          .toList();

      await database.insertBookingWithItems(record, items);
      basket.empty();
      if (!mounted) {
        return;
      }
      setState(() {
        _finalmessage = 'Booking $bookingNumber saved!';
      });
      _loadPastOrders();
      Navigator.pushNamed(context, '/bookings');
    } catch (error) {
      if (!mounted) {
        return;
      }
      final String message = 'Could not save your booking: $error';
      setState(() {
        _finalmessage = message;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _loadPastOrders() async {
    try {
      final CinemaDatabase database = CinemaDatabase.instance;
      final List<BookingRecord> bookings = await database.getAllOrders();
      final List<OrderItem> items = await database.getAllOrderItems();
      final Map<int, List<OrderItem>> itemsByBooking = <int, List<OrderItem>>{};

      for (final OrderItem item in items) {
        final int? bookingId = item.bookingId;
        if (bookingId == null) {
          continue;
        }
        itemsByBooking.putIfAbsent(bookingId, () => <OrderItem>[]).add(item);
      }

      if (!mounted) {
        return;
      }
      setState(() {
        _pastBookings = bookings;
        _pastItemsByBooking = itemsByBooking;
        _loadingPastOrders = false;
        _pastOrdersError = '';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      final String message = 'Could not load past orders: $error';
      setState(() {
        _loadingPastOrders = false;
        _pastOrdersError = message;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.0),
          child: Text(
            'No tickets in cart',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          )),
    );
  }

  Widget _buildMovieItem(BasketRepository basket, BasketItem movie, int idx) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${movie.quantity} Tickets',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cinemaBrandDark,
                      fontSize: 18),
                ),
                const SizedBox(width: 15),
                SizedBox(
                    width: 120,
                    child: Text(
                      '${movie.movie.name},\n${movie.movie.showingDateTime}',
                      style: TextStyle(fontSize: 17),
                    )),
                const SizedBox(width: 10),
                Text(
                  '£${movie.movieTotal.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(
                    icon: const Icon(Icons.delete_outline),
                    style: IconButton.styleFrom(
                        backgroundColor: cinemaBrand,
                        foregroundColor: cinemaFontWhite,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero)),
                    onPressed: () {
                      setState(() {
                        basket.removeMovie(idx);
                      });
                    }),
              ],
            )
          ],
        ));
  }

  Widget _buildRows(String details, String price, {bool emphasise = false}) {
    final TextStyle style;
    if (emphasise) {
      style = const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    } else {
      style = const TextStyle(color: cinemaFontWhite);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(details, style: style),
          Text(price, style: style),
        ],
      ),
    );
  }

  Widget _buildBasketList(BasketRepository basket, List<BasketItem> movies) {
    final List<Widget> children = [];

    children.add(const Text('MY ORDER', style: cinemaHeaderStyle));
    children.add(const SizedBox(height: 16));
    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Item',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(width: 20),
          Text('Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(width: 42),
          Text('Price',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(width: 28)
        ],
      ),
    );

    for (int idx = 0; idx < movies.length; idx++) {
      final BasketItem movie = movies[idx];
      children.add(_buildMovieItem(basket, movie, idx));
    }
    children.add(
      _buildRows(
        'Service Charge',
        '£${basket.getSurcharge().toStringAsFixed(2)}',
      ),
    );
    children.add(
      _buildRows(
        'Total Due',
        '£${basket.getAmountDue().toStringAsFixed(2)}',
        emphasise: true,
      ),
    );
    children.add(SizedBox(
      height: 20,
    ));

    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MainButton(label: 'UPDATE ORDER', onPressed: () {}),
          const SizedBox(width: 8),
          MainButton(
            label: 'BUY TICKETS',
            onPressed: () {
              _checkout(basket, movies);
            },
          ),
        ],
      ),
    );

    if (_finalmessage.isNotEmpty) {
      children.add(const SizedBox(
        height: 12,
      ));
      children.add(Text(_finalmessage,
          style: const TextStyle(fontWeight: FontWeight.bold)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildPastOrder(BookingRecord booking) {
    final List<OrderItem> items = _pastItemsByBooking[booking.id] ?? [];
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking #${booking.bookingNumber}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(booking.date),
            const SizedBox(height: 8),
            if (items.isEmpty)
              Text(booking.summary)
            else
              for (final OrderItem item in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${item.quantity}x ${item.movieName}\n'
                    '${item.showingDateTime}\n'
                    'Unit price: £${item.unitPrice.toStringAsFixed(2)} | '
                    'Item total: £${item.lineTotal.toStringAsFixed(2)}',
                  ),
                ),
            Text('Total: £${booking.total.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildPastOrders() {
    if (_loadingPastOrders) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_pastOrdersError.isNotEmpty) {
      return Text(_pastOrdersError);
    }
    if (_pastBookings.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'PAST ORDERS',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        for (final BookingRecord booking in _pastBookings)
          _buildPastOrder(booking),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final BasketRepository basket = BasketRepository.instance;
    final List<BasketItem> movies = basket.getMovies();

    final Widget content;
    if (movies.isEmpty) {
      if (_finalmessage.isNotEmpty) {
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmptyState(),
            const SizedBox(height: 15),
            Center(
              child: Text(_finalmessage,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        );
      } else {
        content = _buildEmptyState();
      }
    } else {
      content = _buildBasketList(basket, movies);
    }
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(title: const Text(appTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            content,
            _buildPastOrders(),
          ],
        ),
      ),
    );
  }
}
