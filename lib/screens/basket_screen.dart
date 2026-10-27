import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/widgets/main_button.dart';
import 'package:southsea_cinema/models/basket_item.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() {
    return _BasketScreenState();
  }
}

class _BasketScreenState extends State<BasketScreen> {
  String _finalmessage = '';

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

    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MainButton(label: 'UPDATE ORDER', onPressed: () {}),
        MainButton(
            label: 'BUY TICKETS',
            onPressed: () {
              setState(() {
                basket.empty();
                _finalmessage =
                    'Thanks, your tickets will be sent to your email address.';
              });
            })
      ],
    ));

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
      appBar: AppBar(title: const Text(appTitle, style: cinemaHeaderStyle)),
      body:
          SingleChildScrollView(padding: EdgeInsets.all(20.0), child: content),
    );
  }
}
