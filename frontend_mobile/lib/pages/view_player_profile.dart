import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../components/rating_display.dart';
import '../components/contact_info_field.dart';
import '../pages/view_player_reviews.dart';
import '../data/player.dart';
import '../data/player_review.dart';
import '../constants.dart';

class ViewPlayerProfile extends StatefulWidget {
  const ViewPlayerProfile({
    super.key,
    required this.player,
  });

  final Player player;

  @override
  State<ViewPlayerProfile> createState() => _ViewPlayerProfileState();
}

class _ViewPlayerProfileState extends State<ViewPlayerProfile> {
  String reviewsButtonsText = 'Display Reviews';
  bool reviewsDisplayed = false;
  List<PlayerReview>? playerReviews;

  void toggleButton() async {
    playerReviews ??= await getReviews();
    setState(() {
      if (reviewsDisplayed) {
        reviewsDisplayed = false;
        reviewsButtonsText = 'Display Reviews';
      } else {
        reviewsDisplayed = true;
        reviewsButtonsText = 'Hide Reviews';
      }
    });
  }

  Future<List<PlayerReview>> getReviews() async {
    Dio dio = Dio();
    final response = await dio.get(
      '$apiRoute/getAPlayersReviews/${widget.player.playerID}',
    );
    List<dynamic> reviewsData = response.data;
    List<PlayerReview> reviews =
        reviewsData.map((e) => PlayerReview.fromJson(e)).toList();
    return reviews;
  }

  int _getAge() {
    try {
      DateTime dateOfBirth = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
          .parse(widget.player.dateOfBirth, false)
          .toLocal();
      DateTime dateToday = DateTime.now();
      Duration difference = dateToday.difference(dateOfBirth);
      return (difference.inDays / 365).floor();
    } catch (e) {
      throw Exception(e);
    }
  }

  String _capitalizeFirstLetter(String str) =>
      str.replaceFirst(str[0], str[0].toUpperCase());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                CircleAvatar(
                  radius: 81.0,
                  backgroundColor: kDarkColor,
                  child: CircleAvatar(
                    radius: 80.0,
                    backgroundImage: widget.player.imageByteArray != null
                        ? Image.memory(widget.player.imageByteArray!).image
                        : const AssetImage(defaultProfilePath),
                  ),
                ),
                const SizedBox(height: 10),
                Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    style: const TextStyle(fontSize: 18),
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.player.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                          text: ' #${widget.player.playerID}',
                          style: const TextStyle(
                            fontSize: 18,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (widget.player.description != null &&
                    widget.player.description!.isNotEmpty)
                  Column(
                    children: [
                      Text(
                        widget.player.description!,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                const Divider(color: kDarkColor),
                const SizedBox(height: 7),
                const Text(
                  'Contact Info',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                ContactInfoField(
                  field: 'Phone Number',
                  value: widget.player.phoneNumber,
                ),
                const SizedBox(height: 10),
                ContactInfoField(
                  field: 'Email',
                  value: widget.player.email,
                ),
                const SizedBox(height: 10),
                ContactInfoField(
                  field: 'Address',
                  value: widget.player.location.place,
                ),
                const SizedBox(height: 10),
                const Divider(color: kDarkColor),
                const SizedBox(height: 7),
                const Text(
                  'Player Attributes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Sex: ',
                          style: TextStyle(fontSize: 18),
                        ),
                        widget.player.sex == Sex.female
                            ? const Icon(Icons.female)
                            : const Icon(Icons.male),
                      ],
                    ),
                    Text(
                      'Age: ${_getAge()}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Position: ${_capitalizeFirstLetter(widget.player.position.value)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Weight: ${widget.player.weight == 0 ? '_' : '${widget.player.weight} KG'}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Height: ${widget.player.height == 0 ? '_' : '${widget.player.height} CM'}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(color: kDarkColor),
                const SizedBox(height: 7),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 18),
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Average Ratings ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: '(${widget.player.numberOfReviews} reviews)',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                RatingDisplay(
                  attribute: '  Morality ',
                  rating: widget.player.averageMoralityRating ?? 0,
                ),
                const SizedBox(height: 2),
                RatingDisplay(
                  attribute: 'Skill Level',
                  rating: widget.player.averageSkillRating ?? 0,
                ),
                const SizedBox(height: 5),
                const Divider(color: kDarkColor),
                ElevatedButton(
                  onPressed: toggleButton,
                  child: Text(
                    reviewsButtonsText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                if (reviewsDisplayed)
                  ViewPlayerReviews(
                    player: widget.player,
                    reviews: playerReviews!,
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
