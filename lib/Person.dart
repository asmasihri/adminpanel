
class Person {
    final String userId;
  final String name;
  final String phoneNumber;
  final String photoUrl;
  final String badgePhotoUrl;
  final String nationalCardFrontUrl;
  final String nationalCardBackUrl;
  final String pickpark;
  final String adress ;
  final String nameparking ; 
  bool isActive;

  Person(
   {

    required  this .pickpark, 
    required  this .adress, 
    required  this .nameparking, 
    required this.name,
    required this.userId,
    required this.phoneNumber,
    required this.photoUrl,
    required this.badgePhotoUrl,
    required this.nationalCardFrontUrl,
    required this.nationalCardBackUrl,
    this.isActive = false,
  });
}
