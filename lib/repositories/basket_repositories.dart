import 'package:southsea_cinema/models/basket_item.dart';

class BasketRepository {
  BasketRepository._internal();

  static final BasketRepository instance = BasketRepository._internal();
  final List<BasketItem> _movies = [];

  List<BasketItem> getMovies() {
    return List<BasketItem>.unmodifiable(_movies);
  }

  void addMovie(BasketItem movie){
    _movies.add(movie);
  }

  void removeMovie(int idx) {
    if (idx >=0 && idx < _movies.length) {
      
    }
  }
}


