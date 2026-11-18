class OrderItem {
  final int? id;
  final int? bookingId;
  final String movieName;
  final String showingDateTime;
  final int quantity;
  final double unitPrice;
  final double lineTotal;

  const OrderItem({
    this.id,
    this.bookingId,
    required this.movieName,
    required this.showingDateTime,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
  });

  Map<String, Object?> toMap() {
    final Map<String, Object?> data = <String, Object?>{
      'movie_name': movieName,
      'showing_date_time': showingDateTime,
      'quantity': quantity,
      'unit_price': unitPrice,
      'line_total': lineTotal,
    };

    if (id != null) {
      data['id'] = id;
    }
    if (bookingId != null) {
      data['booking_id'] = bookingId;
    }
    return data;
  }

  factory OrderItem.fromMap(Map<String, Object?> map) {
    final num unitPrice = map['unit_price'] as num;
    final num lineTotal = map['line_total'] as num;

    return OrderItem(
      id: map['id'] as int?,
      bookingId: map['booking_id'] as int?,
      movieName: map['movie_name'] as String,
      showingDateTime: map['showing_date_time'] as String,
      quantity: map['quantity'] as int,
      unitPrice: unitPrice.toDouble(),
      lineTotal: lineTotal.toDouble(),
    );
  }
}
