import 'package:flutter/material.dart';
import '../data/sport_center.dart';
import '../constants.dart';
import '../components/average_rating_display.dart';
import '../components/copyable_link.dart';
import '../components/facility_info.dart';
import '../components/field_info.dart';
import '../components/sport_center_attribute.dart';

class ViewSportCenterProfile extends StatelessWidget {
  const ViewSportCenterProfile({
    super.key,
    required this.sportCenter,
  });

  final SportCenter sportCenter;

  @override
  Widget build(BuildContext context) {
    List<Widget> fieldWidgets = sportCenter.fields
        .map(
          (field) => FieldInfo(field: field),
        )
        .toList();
    List<Widget> facilityWidgets = sportCenter.facilitiesAvailable!
        .map(
          (facility) => FacilityInfo(
            facility: facility,
          ),
        )
        .toList();
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
                const SizedBox(height: 10),
                SportCenterAttribute(
                  text: 'Location: ${sportCenter.location.place}',
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 5),
                SportCenterAttribute(
                  text: 'Phone Number: ${sportCenter.phoneNumber}',
                  icon: Icons.phone,
                ),
                const SizedBox(height: 5),
                SportCenterAttribute(
                  text: 'Working hours: ${sportCenter.workingHours}',
                  icon: Icons.timelapse,
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
                        text: '(${sportCenter.nbOfRatings} reviews)',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                AverageRatingDisplay(
                  attribute: '  Staff Service ',
                  rating: sportCenter.staffServiceAverageRating ?? 0,
                ),
                const SizedBox(height: 2),
                AverageRatingDisplay(
                  attribute: 'Facility Quality',
                  rating: sportCenter.facilityQualityAverageRating ?? 0,
                ),
                const Divider(color: kDarkColor),
                const Text(
                  'Fields',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Wrap(
                  children: List.generate(fieldWidgets.length, (index) {
                    if (index % 2 == 0) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          fieldWidgets[index],
                          if (index + 1 < fieldWidgets.length)
                            const SizedBox(width: 10),
                          if (index + 1 < fieldWidgets.length)
                            fieldWidgets[index + 1],
                        ],
                      );
                    }
                    return Container();
                  }),
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
                      const SizedBox(height: 7),
                      Wrap(
                        children:
                            List.generate(facilityWidgets.length, (index) {
                          if (index % 2 == 0) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                facilityWidgets[index],
                                if (index + 1 < facilityWidgets.length)
                                  const SizedBox(width: 10),
                                if (index + 1 < facilityWidgets.length)
                                  facilityWidgets[index + 1],
                              ],
                            );
                          }
                          return Container();
                        }),
                      ),
                    ],
                  )
                else
                  Column(
                    children: const [
                      Divider(color: kDarkColor),
                      Text(
                        'No Facilities Added',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10)
                    ],
                  ),
                const Divider(color: kDarkColor),
                const SizedBox(height: 7),
                const Text(
                  'Usefull Links',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                CopyableLink(
                    link: sportCenter.locationLink, linkApp: 'Google Maps'),
                const SizedBox(height: 8),
                CopyableLink(link: sportCenter.linkToFB, linkApp: 'Facebook'),
                const SizedBox(height: 8),
                CopyableLink(
                    link: sportCenter.linkToInsta, linkApp: 'Instagram'),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
