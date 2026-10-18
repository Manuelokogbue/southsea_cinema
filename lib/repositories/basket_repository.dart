import 'package:southsea_cinema/models/basket_item.dart';

class BasketRepository {
  BasketRepository._internal();

  static final BasketRepository instance = BasketRepository._internal();
  final List<BasketItem> _movies = [];

  List<BasketItem> getMovies() {
    return List<BasketItem>.unmodifiable(_movies);
  }

  void addMovie(BasketItem movie) {
    _movies.add(movie);
  }

  void removeMovie(int idx) {
    if (idx >= 0 && idx < _movies.length) {
      _movies.removeAt(idx);
    }
  }

  int getTotalMovies() {
    int total = 0;
    for (final BasketItem movie in _movies) {
      total += movie.quantity;
    }
    return total;
  }

  int get numberOfMovies {
    return getTotalMovies();
  }

  double getMovieTotal() {
    double total = 0.0;
    for (final BasketItem movie in _movies) {
      total += movie.movieTotal;
    }
    return total;
  }

  double getSurcharge() {
    if (_movies.isEmpty) {
      return 0.0;
    }
    return 4.00;
  }

  double getAmountDue() {
    return getMovieTotal() + getSurcharge();
  }

  void empty() {
    _movies.clear();
  }
}
