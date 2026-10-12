class Movie{
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

  const Movie({required this.id, required this.name, required this.description, required this.showingDateTime, required this.imagePath, required this.rating, required this.duration, required this.pg, required this.genre, required this.price});

  String get formattedPrice =>'£${price.toStringAsFixed(2)}';

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

}