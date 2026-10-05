import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';

class MovieBooking extends StatelessWidget {
  final Movie movie;

  const MovieBooking(this.movie, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(movie.name,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: cinemaFontWhite)),
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 170,
                      height: 200,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 89, 115, 151),
                          borderRadius: BorderRadius.circular(8)),
                      child: Image.asset(
                        movie.imagePath,
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                          movie.showingDateTime,
                          style:
                              const TextStyle(fontSize: 16, color: cinemaFontWhite)),
                    ),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 180,
                      height: 200,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 89, 115, 151),
                          borderRadius: BorderRadius.circular(8)),
                      child: Image.asset(
                        movie.imagePath,
                        width: 170,
                        height: 180,
                        alignment: Alignment.center,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(movie.showingDateTime,
                        style: const TextStyle(
                            color: cinemaFontWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ],
                );
              }
            }),
            const SizedBox(height: 6),
            Text(
                '${movie.name}, \n ${movie.duration} | ${movie.genre} | ${movie.rating}',
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 16,
                    height: 2,
                    fontWeight: FontWeight.bold,
                    color: cinemaFontWhite)),
            const SizedBox(height: 10),
            Order(movie:movie)
          ],
        ));
  }
}

class Order extends StatefulWidget {
  final Movie movie;

  const Order({super.key, required this.movie});

  @override
  State<Order> createState() {
    return _Orders();
  }
}

class _Orders extends State<Order> {
  int maxTickets = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Book${widget.movie.name}'),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            DropdownMenu<int>(
                initialSelection: maxTickets,
                onSelected: (int? value) {
                  if (value != null) {
                    setState(() {
                      maxTickets = value;
                    });
                  }
                },
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 1, label: '1'),
                  DropdownMenuEntry(value: 2, label: '2'),
                  DropdownMenuEntry(value: 3, label: '3'),
                  DropdownMenuEntry(value: 4, label: '4'),
                  DropdownMenuEntry(value: 5, label: '5'),
                ]),
            const SizedBox(width: 8),
            const Text('Adult (£7.50)'),
            const SizedBox(width: 5),
            const Text('*Discounts will be applied at checkout.',
                style: TextStyle(fontSize: 9))
          ]),
          SizedBox(height: 10),
          ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Added $maxTickets ticket(s) to cart!')));
              },
              child: const Text('Add to order')),
        ]));
  }
}
