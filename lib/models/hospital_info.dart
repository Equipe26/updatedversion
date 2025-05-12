class HospitalInfo {
  final String name;
  final String imageUrl;
  final double rating;
  final int reviews;
  final List<String> specialties;
  final List<String> services;
  final String address;
  final String phone;
  final String email;
  final List<String> workHours;

  HospitalInfo({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.specialties,
    required this.services,
    required this.address,
    required this.phone,
    required this.email,
    required this.workHours,
  });
}
