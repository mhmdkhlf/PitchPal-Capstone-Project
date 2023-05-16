import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'view_sport_center_reviews.dart';
import '../data/sport_center.dart';
import '../data/sport_center_review.dart';
import '../constants.dart';
import '../components/rating_display.dart';
import '../components/copyable_link.dart';
import '../components/facility_info.dart';
import '../components/field_info.dart';
import '../components/sport_center_attribute.dart';

class ViewSportCenterProfile extends StatefulWidget {
  const ViewSportCenterProfile({
    super.key,
    required this.sportCenter,
    this.isPlayerApp = true,
  });

  final SportCenter sportCenter;
  final bool isPlayerApp;

  @override
  State<ViewSportCenterProfile> createState() => _ViewSportCenterProfileState();
}

class _ViewSportCenterProfileState extends State<ViewSportCenterProfile> {
  String reviewsButtonsText = 'Display Reviews';
  bool reviewsDisplayed = false;
  List<SportCenterReview>? sportCenterReviews;

  void toggleButton() async {
    sportCenterReviews ??= await getReviews();
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

  Future<List<SportCenterReview>> getReviews() async {
    Dio dio = Dio();
    final response = await dio.get(
      '$apiRoute/getASportCentersReviews/${widget.sportCenter.name}',
    );
    List<dynamic> reviewsData = response.data;
    List<SportCenterReview> reviews =
        reviewsData.map((e) => SportCenterReview.fromJson(e)).toList();
    return reviews;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> fieldWidgets = widget.sportCenter.fields
        .map(
          (field) => FieldInfo(field: field),
        )
        .toList();
    List<Widget> facilityWidgets = widget.sportCenter.facilitiesAvailable!
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
                    image: widget.sportCenter.imageByteArray != null
                        ? Image.memory(widget.sportCenter.imageByteArray!).image
                        : const AssetImage(defaultSportCenterImagePath),
                    height: 168,
                    width: 300,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.sportCenter.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                SportCenterAttribute(
                  text: 'Location: ${widget.sportCenter.location.place}',
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 5),
                SportCenterAttribute(
                  text: 'Phone Number: ${widget.sportCenter.phoneNumber}',
                  icon: Icons.phone,
                ),
                const SizedBox(height: 5),
                SportCenterAttribute(
                  text: 'Working hours: ${widget.sportCenter.workingHours}',
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
                        text: '(${widget.sportCenter.nbOfRatings} reviews)',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RatingDisplay(
                  attribute: '  Staff Service ',
                  rating: widget.sportCenter.staffServiceAverageRating ?? 0,
                ),
                const SizedBox(height: 2),
                RatingDisplay(
                  attribute: 'Facility Quality',
                  rating: widget.sportCenter.facilityQualityAverageRating ?? 0,
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
                if (widget.sportCenter.facilitiesAvailable != null &&
                    widget.sportCenter.facilitiesAvailable!.isNotEmpty)
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
                    link: widget.sportCenter.locationLink,
                    linkApp: 'Google Maps'),
                const SizedBox(height: 8),
                CopyableLink(
                  link: widget.sportCenter.linkToFB,
                  linkApp: 'Facebook',
                ),
                const SizedBox(height: 8),
                CopyableLink(
                  link: widget.sportCenter.linkToInsta,
                  linkApp: 'Instagram',
                ),
                if (!widget.isPlayerApp) const SizedBox(height: 20),
                if (widget.isPlayerApp) const SizedBox(height: 7),
                if (widget.isPlayerApp)
                  Column(
                    children: [
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
                        ViewSportCenterReviews(
                          sportCenter: widget.sportCenter,
                          reviews: sportCenterReviews!,
                        ),
                      const SizedBox(height: 20),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
