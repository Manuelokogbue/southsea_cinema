import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cinemaBackground,
      shadowColor: Colors.black,
      elevation: 20,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  movie.name,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: cinemaBrandDark,
                  ),
                ),
                const SizedBox(width: 13),
                Text(
                  'PG(${movie.pg.toString()})',
                  style: TextStyle(
                    fontSize: 19,
                    color: cinemaFontMuted,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            movie.imagePath,
                            width: 190,
                            height: 230,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.description,
                                  style: TextStyle(fontSize: 23),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 13),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            movie.showingDateTime,
                            style: TextStyle(
                              fontSize: 20,
                              color: cinemaFontWhite,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3FB5D9),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return MovieListing(movie: movie);
                                }),
                              );
                            },
                            child: const Text(
                              'BOOK NOW',
                              style: TextStyle(
                                fontSize: 21,
                                color: cinemaFontWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            movie.imagePath,
                            width: 120,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.description,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 13),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.showingDateTime,
                            style: TextStyle(
                              fontSize: 16,
                              color: cinemaFontWhite,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3FB5D9),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return MovieListing(movie: movie);
                                }),
                              );
                            },
                            child: const Text(
                              'BOOK NOW',
                              style: TextStyle(
                                fontSize: 18,
                                color: cinemaFontWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}