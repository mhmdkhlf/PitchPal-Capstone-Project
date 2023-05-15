import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/rating_display.dart';
import '../components/contact_info_field.dart';
import '../data/player.dart';
import '../constants.dart';

class ViewPlayerProfile extends StatelessWidget {
  const ViewPlayerProfile({
    super.key,
    required this.player,
  });

  final Player player;

  int _getAge() {
    try {
      DateTime dateOfBirth = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
          .parse(player.dateOfBirth, false)
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
                    backgroundImage: player.imageByteArray != null
                        ? Image.memory(player.imageByteArray!).image
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
                        text: player.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                          text: ' #${player.playerID}',
                          style: const TextStyle(
                            fontSize: 18,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (player.description != null &&
                    player.description!.isNotEmpty)
                  Column(
                    children: [
                      Text(
                        player.description!,
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
                  value: player.phoneNumber,
                ),
                const SizedBox(height: 10),
                ContactInfoField(
                  field: 'Email',
                  value: player.email,
                ),
                const SizedBox(height: 10),
                ContactInfoField(
                  field: 'Address',
                  value: player.location.place,
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
                        player.sex == Sex.female
                            ? const Icon(Icons.female)
                            : const Icon(Icons.male),
                      ],
                    ),
                    Text(
                      'Age: ${_getAge()}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Position: ${_capitalizeFirstLetter(player.position.value)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Weight: ${player.weight} KG',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Height: ${player.height} CM',
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
                        text: '(${player.numberOfReviews} reviews)',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                RatingDisplay(
                  attribute: '  Morality ',
                  rating: player.averageMoralityRating ?? 0,
                ),
                const SizedBox(height: 2),
                RatingDisplay(
                  attribute: 'Skill Level',
                  rating: player.averageSkillRating ?? 0,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
