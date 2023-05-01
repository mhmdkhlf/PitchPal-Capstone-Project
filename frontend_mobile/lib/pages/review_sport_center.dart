import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../components/textfield_input.dart';
import '../components/response_dialog_box.dart';
import '../components/submit_button.dart';

class ReviewSportCenter extends StatelessWidget {
  final String sportCenterName;
  final TextEditingController reviewTextInput;

  const ReviewSportCenter({
    super.key,
    required this.sportCenterName,
    required this.reviewTextInput,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Review $sportCenterName',
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFieldInput(
                controller: reviewTextInput,
                hintText: 'Review Text',
                isMultiLine: true,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Staff Service: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  RatingBar.builder(
                    initialRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) => {},
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Facility Quality: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  RatingBar.builder(
                    initialRating: 1,
                    direction: Axis.horizontal,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) => {},
                  ),
                ],
              ),
              const SizedBox(height: 15),
              SubmitButton(
                text: 'Submit Review',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => (const ResponseDialogBox(
                        text: 'You Successfully submitted a Review',
                      )),
                    ),
                  );
                },
                fontSize: 18,
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
