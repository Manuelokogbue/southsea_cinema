import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
        child: Padding(
          padding: const EdgeInsetsGeometry.all(5.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${movie.name}  ${movie.pg.toString()}',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: cinemaBrand),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(movie.imagePath,
                      width: 160, height: 200, fit: BoxFit.cover),
                  const SizedBox(width: 13),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(movie.description)],
                  ))
                ],
              ),
              const SizedBox(height: 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(movie.showingDateTime,
                      style: TextStyle(fontSize: 16, color: cinemaFontWhite)),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'BOOK NOW',
                      style: TextStyle(fontSize: 23, color: cinemaFontWhite),
                    )
                  )
                ],
              )
            ],
          ),
        ));
  }
}
