class ProductDto {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final RatingDto rating;

  ProductDto.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      title = json['title'],
      price = (json['price'] as num).toDouble(),
      description = json['description'],
      category = json['category'],
      image = json['image'],
      rating = RatingDto.fromJson(json['rating'] as Map<String, dynamic>);
}

class RatingDto {
  final double rate;
  final int count;

  const RatingDto({required this.rate, required this.count});

  factory RatingDto.fromJson(Map<String, dynamic> json) {
    return RatingDto(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }
}
