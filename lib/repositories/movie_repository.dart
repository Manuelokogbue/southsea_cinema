import 'package:southsea_cinema/models/movie.dart';

class MovieRepository {
  List<Movie> getMovies() {
    return const[
      Movie(id: 'anna', name: 'ANNABELLE', description: 'A couple begins to experience terrifying supernatural occurrences involving a vintage doll shortly after their home is invaded by satanic cultists.', showingDateTime: 'Friday 30th Oct, 2026 12:00PM', imagePath: 'assets/images/Annabelle.jpeg', rating: 'IMDB Rating: 7.67', duration: '2hrs 45mins', pg: 15, genre: 'Horror'),
      Movie(id: 'Hamil', name: 'HAMILTON', description: "The real life of one of America's foremost founding fathers and first Secretary of the Treasury, Alexander Hamilton. Captured live on Broadway from the Richard Rodgers Theater with the original Broadway cast.", showingDateTime: 'Sunday 25th October, 2026 09:00AM', imagePath: 'assets/images/Hamilton.jpeg', rating: 'IMDB Rating: 8.30', duration: "2hrs 40mins", pg: 18, genre: 'Musical')
    ];
  }
}