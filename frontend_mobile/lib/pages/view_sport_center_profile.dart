import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/field.dart';
import '../data/sport_center.dart';
import '../constants.dart';
import '../components/average_rating_display.dart';
import '../components/contact_info_field.dart';

//TODO restyle this view, make it prettier :=)
class ViewSportCenterProfile extends StatelessWidget {
  const ViewSportCenterProfile({
    super.key,
    required this.sportCenter,
  });

  final SportCenter sportCenter;

  String _displayLink(String? link) {
    return link != null && link.isNotEmpty ? link : '_';
  }

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    image: sportCenter.imageByteArray != null
                        ? Image.memory(sportCenter.imageByteArray!).image
                        : const AssetImage(defaultSportCenterImagePath),
                    height: 168,
                    width: 300,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  sportCenter.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timelapse),
                    Text(
                      ' ${sportCenter.workingHours}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
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
                  value: sportCenter.phoneNumber,
                ),
                const SizedBox(height: 10),
                ContactInfoField(
                  field: 'Address',
                  value: sportCenter.location.place,
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                  ),
                  child: const Text(
                    'Open in\nGoogle Maps',
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () => launchUrl(
                    Uri.parse(sportCenter.locationLink),
                  ),
                ),
                const Divider(color: kDarkColor),
                const Text(
                  'Fields',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: sportCenter.fields.length,
                  itemBuilder: (context, index) {
                    Field field = sportCenter.fields[index];
                    return Column(
                      children: [
                        Text(
                          'Field #${field.fieldNumber}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        ContactInfoField(
                          field: 'Field Length',
                          value: field.fieldLength.toString(),
                        ),
                        const SizedBox(height: 10),
                        ContactInfoField(
                          field: 'Field Width',
                          value: field.fieldWidth.toString(),
                        ),
                        const SizedBox(height: 10),
                        ContactInfoField(
                          field: 'Grass type',
                          value: field.grassType.value,
                        ),
                        const SizedBox(height: 10),
                        ContactInfoField(
                          field: 'Recommended Team size',
                          value: field.recommendedTeamSize.toString(),
                        ),
                        const SizedBox(height: 10),
                        ContactInfoField(
                          field: 'Reservation Price',
                          value: '${field.reservationPrice} \$',
                        ),
                        if (index != sportCenter.fields.length - 1)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Divider(
                              thickness: 2,
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 7),
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
                        text: '(${sportCenter.nbOfRatings} reviews)',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                AverageRatingDisplay(
                  attribute: '  Staff Service ',
                  rating: sportCenter.staffServiceAverageRating ?? 0,
                ),
                const SizedBox(height: 2),
                AverageRatingDisplay(
                  attribute: 'Facility Quality',
                  rating: sportCenter.facilityQualityAverageRating ?? 0,
                ),
                const SizedBox(height: 10),
                if (sportCenter.facilitiesAvailable != null &&
                    sportCenter.facilitiesAvailable!.isNotEmpty)
                  Column(
                    children: [
                      const Divider(color: kDarkColor),
                      const Text(
                        'Facilities Available',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: sportCenter.facilitiesAvailable!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              const SizedBox(height: 15),
                              Text(
                                'Facility #${index + 1}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                sportCenter.facilitiesAvailable![index].name,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                sportCenter
                                    .facilitiesAvailable![index].description,
                                maxLines: 3,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  )
                else
                  Column(
                    children: const [
                      Divider(color: kDarkColor),
                      Text(
                        'No Facilities Added.',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10)
                    ],
                  ),
                const Divider(color: kDarkColor),
                const SizedBox(height: 7),
                const Text(
                  'Social Medias',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                ContactInfoField(
                  field: 'Facebook link',
                  value: _displayLink(sportCenter.linkToInsta),
                ),
                const SizedBox(height: 10),
                ContactInfoField(
                  field: 'Instagram link',
                  value: _displayLink(sportCenter.linkToInsta),
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
