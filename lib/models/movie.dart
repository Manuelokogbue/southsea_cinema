class Movie {
  final String id;
  final String name;
  final String description;
  final String showingDateTime;
  final String imagePath;
  final String rating;
  final String duration;
  final String pg;
  final String genre;
  final double price;

  const Movie(
      {required this.id,
      required this.name,
      required this.description,
      required this.showingDateTime,
      required this.imagePath,
      required this.rating,
      required this.duration,
      required this.pg,
      required this.genre,
      required this.price});

  String get formattedPrice => '£${price.toStringAsFixed(2)}';

  bool get isChildFriendly {
    if (pg == 'U' || pg == 'PG') {
      return true;
    } else {
      return false;
    }
  }

  bool get isAdultOnly {
    if (pg == '18') {
      return true;
    } else {
      return false;
    }
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    final String id = json['id'] as String;
    final String name = json['name'] as String;
    final String description = json['description'] as String;
    final String showingDateTime = json['showingDateTime'];
    final String imagePath = json['imagePath'] as String;
    final String rating = json['rating'] as String;
    final String duration = json['duration'] as String;
    final String pg = json['pg'] as String;
    final String genre = json['genre'] as String;
    final num priceNumber = json['price'] as num;
    final double price = priceNumber.toDouble();

    return Movie(
      id: id,
      name: name,
      description: description,
      showingDateTime: showingDateTime,
      imagePath: imagePath,
      rating: rating,
      duration: duration,
      pg: pg,
      genre: genre,
      price: price,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'showingDateTime': showingDateTime,
      'imagePath': imagePath,
      'rating': rating,
      'duration': duration,
      'pg': pg,
      'genre': genre,
      'price': price,
    };
    return data;
  }
}
