import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/pages/view_field_manager_profile.dart';
import 'package:frontend_mobile/pages/view_sport_center_profile.dart';
import 'package:frontend_mobile/pages/field_bookings.dart';
import 'package:frontend_mobile/pages/view_sport_center_reviews.dart';
import '../data/field.dart';
import '../data/field_manager.dart';
import '../data/reservation.dart';
import '../data/sport_center.dart';
import '../data/sport_center_review.dart';
import '../constants.dart';

class FieldManagerHomePage extends StatefulWidget {
  const FieldManagerHomePage({
    super.key,
    required this.fieldManager,
  });

  final FieldManager fieldManager;

  @override
  State<FieldManagerHomePage> createState() => _FieldManagerHomePageState();
}

class _FieldManagerHomePageState extends State<FieldManagerHomePage> {
  int _selectNavBarItemIndex = 0;
  SportCenter? sportCenter;
  List<Reservation>? sportCenterReservations;
  List<SportCenterReview>? sportCenterReviews;

  Future<SportCenter> getSportCenter() async {
    final Dio dio = Dio();
    final response = await dio.get(
      '$apiRoute/getSportCenter/${widget.fieldManager.sportCenterName}',
    );
    sportCenter = SportCenter.fromJson(response.data);
    final imageResponse = await dio.get(
      '$apiRoute/getSportCenterProfilePictureByName/${sportCenter!.name}',
    );
    if (imageResponse.data != null) {
      List<dynamic> dynamicList = imageResponse.data['img']['data']['data'];
      List<int> intList = dynamicList.map((e) => e as int).toList();
      Uint8List imageData = Uint8List.fromList(intList);
      sportCenter!.imageByteArray = imageData;
    }
    final fieldsResponse = await dio.get(
      '$apiRoute/getFields/${sportCenter!.name}',
    );
    List<dynamic> fieldsData = fieldsResponse.data;
    List<Field> fields = fieldsData.map((e) => Field.fromJson(e)).toList();
    fields.sort((a, b) => a.fieldNumber.compareTo(b.fieldNumber));
    sportCenter!.fields = fields;
    return sportCenter!;
  }

  Future<List<SportCenterReview>> getReviews() async {
    Dio dio = Dio();
    final response = await dio.get(
      '$apiRoute/getASportCentersReviews/${sportCenter!.name}',
    );
    List<dynamic> reviewsData = response.data;
    List<SportCenterReview> reviews =
        reviewsData.map((e) => SportCenterReview.fromJson(e)).toList();
    sportCenterReviews = reviews;
    return reviews;
  }

  Future<Map<String, dynamic>> getSportCenterAndReservations() async {
    Map<String, dynamic> output = {};
    sportCenter ??= await getSportCenter();
    output['sportCenter'] = sportCenter;
    Dio dio = Dio();
    final response = await dio.get(
      '$apiRoute/getAllReservationsBySportCenter/${sportCenter!.name}',
    );
    List<dynamic> reservationsData = response.data;
    List<Reservation> reservations =
        reservationsData.map((e) => Reservation.fromJson(e)).toList();
    output['reservations'] = reservations;
    sportCenterReservations = reservations;
    return output;
  }

  AppBar? getAppBar() {
    if (_selectNavBarItemIndex == 0) {
      return AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
            child: Text(
          'Reservation Management',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        )),
      );
    }
    if (_selectNavBarItemIndex == 1) {
      return AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "${sportCenter!.name}'s reviews",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }
    return null;
  }

  Widget getBody() {
    if (_selectNavBarItemIndex == 0) {
      if (sportCenter != null && sportCenterReservations != null) {
        return FieldBookings(
          sportCenter: sportCenter!,
          reservations: sportCenterReservations!,
        );
      }
      return FutureBuilder(
        future: getSportCenterAndReservations(),
        builder: (context, future) {
          if (future.hasData) {
            return FieldBookings(
              sportCenter: future.data!['sportCenter'],
              reservations: future.data!['reservations'],
            );
          }
          if (future.hasError) {
            return Center(child: Text(future.error.toString()));
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    }
    if (_selectNavBarItemIndex == 1) {
      if (sportCenter != null && sportCenterReviews != null) {
        return ViewSportCenterReviews(
          sportCenter: sportCenter!,
          reviews: sportCenterReviews!,
        );
      }
      return FutureBuilder(
        future: getReviews(),
        builder: (context, reviews) {
          if (reviews.hasData) {
            return ViewSportCenterReviews(
              sportCenter: sportCenter!,
              reviews: reviews.data!,
            );
          }
          if (reviews.hasError) {
            return Center(child: Text(reviews.error.toString()));
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    }
    if (_selectNavBarItemIndex == 2) {
      if (sportCenter != null) {
        return ViewSportCenterProfile(
          sportCenter: sportCenter!,
          isPlayerApp: false,
        );
      }
      return FutureBuilder(
        future: getSportCenter(),
        builder: (context, sportCenter) {
          if (sportCenter.hasData) {
            return ViewSportCenterProfile(
              sportCenter: sportCenter.data!,
              isPlayerApp: false,
            );
          }
          if (sportCenter.hasError) {
            return Center(child: Text(sportCenter.error.toString()));
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    }
    return ViewFieldManagerProfile(fieldManager: widget.fieldManager);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        selectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.edit_calendar,
              color: kDarkColor,
            ),
            label: 'Field Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.reviews,
              color: kDarkColor,
            ),
            label: 'Reviews',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CustomIcon.soccerBall,
              color: kDarkColor,
              size: 22,
            ),
            label: 'Sport-Center',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: kDarkColor,
            ),
            label: 'Your Profile',
          ),
        ],
        currentIndex: _selectNavBarItemIndex,
        selectedItemColor: kDarkColor,
        onTap: (index) => setState(() => _selectNavBarItemIndex = index),
        elevation: 5,
      ),
    );
  }
}
