import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/models/HealthcareProfessional.dart';
import 'package:flutter_application_2/models/Patient_service.dart';
import 'package:flutter_application_2/models/Rating_service.dart';
import 'package:flutter_application_2/models/HealthcareProfessionalService.dart';
import 'package:flutter_application_2/models/Comment_service.dart';
import 'info_page.dart';
import 'comment_page.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  static const Color textColor = Color.fromARGB(255, 19, 87, 114);
  static const Color primaryColor = Color(0xFF396C9B);
  static const Color accentColor = Color.fromARGB(255, 53, 111, 134);

  late PatientService _patientService;
  late HealthcareProfessionalService _healthcareService;
  final CommentService _commentService = CommentService();
  String? _currentUserId;
  List<HealthcareProfessional> _favoriteProfessionals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _patientService = PatientService();
    _healthcareService = HealthcareProfessionalService();
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;
    _loadFavoriteProfessionals();
  }

  Future<void> _loadFavoriteProfessionals() async {
    if (_currentUserId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final favorites = await _patientService.getFavoriteHealthcareProfessionals(
        patientId: _currentUserId!,
      );
      setState(() {
        _favoriteProfessionals = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading favorites: ${e.toString()}')),
      );
    }
  }

  Future<void> _removeFavorite(String professionalId) async {
    if (_currentUserId == null) return;

    try {
      await _patientService.removeFavoriteHealthcareProfessional(
        patientId: _currentUserId!,
        professionalId: professionalId,
      );
      await _loadFavoriteProfessionals();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed from favorites')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing favorite: ${e.toString()}')),
      );
    }
  }

  void _showRatingDialog(BuildContext context, HealthcareProfessional professional) {
    double currentRating = professional.rating;
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: Text('Rate ${professional.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Select a rating between 1 and 5 stars'),
                  SizedBox(height: 20),
                  // Custom star rating without flutter_rating_bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < currentRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            currentRating = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          setState(() => isSubmitting = true);
                          try {
                            final ratingService = Provider.of<RatingService>(
                                dialogContext,
                                listen: false);
                            await ratingService.submitRating(
                              professionalId: professional.id,
                              patientId: FirebaseAuth.instance.currentUser?.uid ?? 'anonymous',
                              rating: currentRating,
                            );
                            Navigator.pop(dialogContext);
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              SnackBar(
                                  content: Text('Thank you for your rating!')),
                            );
                            _loadFavoriteProfessionals();
                          } catch (e) {
                            setState(() => isSubmitting = false);
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Error submitting rating: ${e.toString()}')),
                            );
                          }
                        },
                  child: isSubmitting
                      ? CircularProgressIndicator()
                      : Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "My Favorites",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : _favoriteProfessionals.isEmpty
              ? Center(child: Text('No favorites found'))
              : _buildFavoriteList(),
    );
  }

  Widget _buildFavoriteList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _favoriteProfessionals.length,
      itemBuilder: (context, index) {
        return _buildProfessionalCard(_favoriteProfessionals[index]);
      },
    );
  }

  Widget _buildProfessionalCard(HealthcareProfessional professional) {
    String specialtyText = professional.specialty != null
        ? professional.specialty!.displayName
        : HealthcareProfessional.typeDisplayMap[professional.type] ?? '';

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(_getProfileImage(professional))),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(professional.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        if (specialtyText.isNotEmpty)
                          Text(specialtyText,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite, color: const Color.fromARGB(255, 132, 196, 248)),
                    onPressed: () => _removeFavorite(professional.id),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _showRatingDialog(context, professional),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            SizedBox(width: 4),
                            FutureBuilder<double>(
                              future: RatingService().getAverageRating(professional.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Text(
                                    '...',
                                    style: TextStyle(color: textColor),
                                  );
                                } else if (snapshot.hasData) {
                                  double rating = snapshot.data!;
                                  return Text(
                                    rating == 0 ? '0' : rating.toStringAsFixed(1),
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    '0',
                                    style: TextStyle(color: textColor),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(Icons.comment, color: accentColor, size: 18),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentsPage(
                                healthcareProfessionalId: professional.id,
                                professionalName: professional.name,
                              ),
                            ),
                          );
                        },
                      ),
                      FutureBuilder<int>(
                        future: _commentService.getCommentCount(professional.id).then((value) => value ?? 0),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text('...', style: TextStyle(color: textColor));
                          } else if (snapshot.hasData) {
                            return Text('${snapshot.data}', 
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ));
                          } else {
                            return Text('0', style: TextStyle(color: textColor));
                          }
                        },
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.location_on, color: accentColor, size: 18),
                      SizedBox(width: 4),
                      Text(professional.wilaya.name,
                          style: TextStyle(color: textColor)),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.info_outline, color: accentColor),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => professional.type == HealthcareType.clinique
                              ? InfoPage(professional: professional)
                              : InfoPage(professional: professional),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getProfileImage(HealthcareProfessional professional) {
    if (professional.type == HealthcareType.pharmacie) {
      return "https://th.bing.com/th/id/R.dc468394184b1fa1283265fdbfe13bea?rik=l98bV4%2fZVlc90g&pid=ImgRaw&r=0";
    } else if (professional.type == HealthcareType.clinique) {
      return "https://cdn-icons-png.flaticon.com/512/7447/7447748.png";
    } else if (professional.type == HealthcareType.laboratoire_analyse) {
      return "https://th.bing.com/th/id/OIP.l2r_Mhu-whNk35KyQRjThAHaE0?w=1200&h=782&rs=1&pid=ImgDetMain";
    } else {
      return professional.gender == Gender.male
          ? "https://th.bing.com/th/id/OIP.El59S1hH5Lecc2P-c3l-9QHaHV?cb=iwp1&w=708&h=701&rs=1&pid=ImgDetMain"
          : "https://th.bing.com/th/id/OIP.6KV81xM8wNW3EBK_L4o64QHaHa?cb=iwp1&w=500&h=500&rs=1&pid=ImgDetMain";
    }
  }
}