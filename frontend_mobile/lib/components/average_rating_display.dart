import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AverageRatingDisplay extends StatelessWidget {
  const AverageRatingDisplay({
    super.key,
    required this.attribute,
    required this.rating,
  });

  final String attribute;
  final num rating;

  double roundToNearestHalf(num rating) {
    double ratingDouled = rating * 2;
    return ratingDouled.round() / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(attribute, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 20),
        RatingBar.builder(
          initialRating: roundToNearestHalf(rating),
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) => {},
          ignoreGestures: true,
        ),
      ],
    );
  }
}
