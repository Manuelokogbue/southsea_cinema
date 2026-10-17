import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/views/movie_listing.dart';
import 'package:southsea_cinema/widgets/main_button.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cinemaBackground,
      shadowColor: Colors.black,
      elevation: 20,
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 20.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 13,
              runSpacing: 4,
              children: [
                Text(
                  movie.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: cinemaBrandDark,
                  ),
                ),
                Text(
                  '(${movie.pg})',
                  style: const TextStyle(
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
                            height: 260,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Text(
                              movie.description,
                              style: const TextStyle(fontSize: 23),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              movie.showingDateTime,
                              style: const TextStyle(
                                fontSize: 20,
                                color: cinemaFontWhite,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          MainButton(
                            label: 'BOOK NOW',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return MovieListing(movie: movie);
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          movie.imagePath,
                          width: 160,
                          height: 240,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        movie.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 13),
                      Text(
                        movie.showingDateTime,
                        style: const TextStyle(
                          fontSize: 16,
                          color: cinemaFontWhite,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3FB5D9),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return MovieListing(movie: movie);
                                },
                              ),
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
