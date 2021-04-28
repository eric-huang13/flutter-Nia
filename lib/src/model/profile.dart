// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  final String phoneNumber;
  final String perfectReferralDescription;
  final String aboutMe;
  final String company;
  final String profession;
  final String title;
  final String hobbies;
  final String specialOffers;
  final String address;
  final String city;
  final String state;
  final String zip;
  final String country;
  final String website;
  final String college;
  final String gradYear;
  final String email;
  final String whatIsYourWhy;
  final String qualifyingQuestions;
  final String birthdate;
  final String mobilePhoneNumber;
  final String yelpReferenceUrl;
  final String googleReferenceUrl;
  final String facebookReferenceUrl;
  final String howWouldYouLikeToBeIntroduced;
  final String avatar;
  final String name;

  Profile({
    @required this.phoneNumber,
    @required this.perfectReferralDescription,
    @required this.aboutMe,
    @required this.company,
    @required this.profession,
    @required this.title,
    @required this.hobbies,
    @required this.specialOffers,
    @required this.address,
    @required this.city,
    @required this.state,
    @required this.zip,
    @required this.country,
    @required this.website,
    @required this.college,
    @required this.gradYear,
    @required this.email,
    @required this.whatIsYourWhy,
    @required this.qualifyingQuestions,
    @required this.birthdate,
    @required this.mobilePhoneNumber,
    @required this.yelpReferenceUrl,
    @required this.googleReferenceUrl,
    @required this.facebookReferenceUrl,
    @required this.howWouldYouLikeToBeIntroduced,
    @required this.avatar,
    @required this.name,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        phoneNumber: json["Phone Number"],
        perfectReferralDescription: json["Perfect Referral Description"],
        aboutMe: json["About Me"],
        company: json["Company"],
        profession: json["Profession"],
        title: json["Title"],
        hobbies: json["Hobbies"],
        specialOffers: json["Special Offers"],
        address: json["Address"],
        city: json["City"],
        state: json["State"],
        zip: json["Zip"],
        country: json["Country"],
        website: json["Website"],
        college: json["College"],
        gradYear: json["Grad Year"],
        email: json["Email"],
        whatIsYourWhy: json["What is your why?"],
        qualifyingQuestions: json["Qualifying Questions"],
        birthdate: json["Birthdate"],
        mobilePhoneNumber: json["Mobile Phone Number"],
        yelpReferenceUrl: json["Yelp Reference URL"],
        googleReferenceUrl: json["Google Reference URL"],
        facebookReferenceUrl: json["Facebook Reference URL"],
        howWouldYouLikeToBeIntroduced:
            json["How would you like to be introduced?"],
        avatar: json["avatar"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "Phone Number": phoneNumber,
        "Perfect Referral Description": perfectReferralDescription,
        "About Me": aboutMe,
        "Company": company,
        "Profession": profession,
        "Title": title,
        "Hobbies": hobbies,
        "Special Offers": specialOffers,
        "Address": address,
        "City": city,
        "State": state,
        "Zip": zip,
        "Country": country,
        "Website": website,
        "College": college,
        "Grad Year": gradYear,
        "Email": email,
        "What is your why?": whatIsYourWhy,
        "Qualifying Questions": qualifyingQuestions,
        "Birthdate": birthdate,
        "Mobile Phone Number": mobilePhoneNumber,
        "Yelp Reference URL": yelpReferenceUrl,
        "Google Reference URL": googleReferenceUrl,
        "Facebook Reference URL": facebookReferenceUrl,
        "How would you like to be introduced?": howWouldYouLikeToBeIntroduced,
      };
}
