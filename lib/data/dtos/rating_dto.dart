import '../../domain/models/rating.dart';

class RatingDto {
  final double rate;
  final int count;

  RatingDto({
    required this.rate,
    required this.count,
  });

  factory RatingDto.fromJson(Map<String, dynamic> json) {
    return RatingDto(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }

  Rating toDomain() {
    return Rating(
      rate: rate,
      count: count,
    );
  }
}
