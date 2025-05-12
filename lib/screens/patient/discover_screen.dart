import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_2/models/HealthcareProfessional.dart';
import 'package:flutter_application_2/models/HealthcareProfessionalService.dart';
import 'package:flutter_application_2/models/Specialty.dart';
import 'package:flutter_application_2/models/Comment_service.dart';
import 'package:flutter_application_2/models/Rating_service.dart';
import 'info_page.dart';
import 'comment_page.dart';
import 'package:flutter_application_2/models/Map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_application_2/models/Patient_service.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  int _selectedFilterIndex = 0;
  HealthcareType? _selectedCategory;
  Specialty? _selectedSpecialty;
  Gender? _selectedGender;
  AlgerianWilayas? _selectedWilaya;
  AlgiersCommunes? _selectedCommune;
  bool _showCategoryOptions = false;
  bool _showSpecialtyOptions = false;
  bool _showGenderOptions = false;
  bool _showWilayaOptions = false;
  bool _showCommuneOptions = false;
  OverlayEntry? _overlayEntry;
  Map<String, bool> _favorites = {};
  List<HealthcareProfessional> _professionals = [];
  bool _isLoading = false;
  late PatientService _patientService;
  String? _currentUserId;

  static const Color textColor = Color.fromARGB(255, 19, 87, 114);
  static const Color primaryColor = Color(0xFF396C9B);
  static const Color accentColor = Color.fromARGB(255, 53, 111, 134);

  final List<String> _filters = [
    'Catégorie',
    'Spécialité',
    'Sexe',
    'Wilaya',
    'Commune'
  ];

  final List<HealthcareType> _categories = [
    HealthcareType.medecin,
    HealthcareType.infermier,
    HealthcareType.pharmacie,
    HealthcareType.clinique,
    HealthcareType.centre_imagerie,
    HealthcareType.laboratoire_analyse,
    HealthcareType.dentiste,
  ];

  final List<Gender> _genders = [Gender.male, Gender.female];

  late HealthcareProfessionalService _healthcareService;
  final CommentService _commentService = CommentService();

  @override
  void initState() {
    super.initState();
    _healthcareService = HealthcareProfessionalService();
    _patientService = PatientService();
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;
    _loadProfessionals();
  }

  Future<void> _loadProfessionals() async {
    setState(() => _isLoading = true);
    try {
      final professionals = await _healthcareService.getAll();
      setState(() {
        _professionals = professionals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de chargement: ${e.toString()}')),
      );
    }
  }

  Future<void> _searchProfessionals() async {
    setState(() => _isLoading = true);
    try {
      final professionals = await _healthcareService.searchWithFilters(
        type: _selectedCategory,
        specialty: _selectedSpecialty,
        gender: _selectedGender,
        wilaya: _selectedWilaya,
        commune:
            _selectedWilaya == AlgerianWilayas.alger ? _selectedCommune : null,
      );
      setState(() {
        _professionals = professionals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de recherche: ${e.toString()}')),
      );
    }
  }

  String _getFilterText(int index) {
    switch (index) {
      case 0:
        return _selectedCategory != null
            ? HealthcareProfessional.typeDisplayMap[_selectedCategory]!
            : _filters[index];
      case 1:
        return _selectedSpecialty != null
            ? _selectedSpecialty!.displayName
            : _filters[index];
      case 2:
        return _selectedGender != null
            ? _selectedGender == Gender.male
                ? 'Homme'
                : 'Femme'
            : _filters[index];
      case 3:
        return _selectedWilaya != null
            ? _selectedWilaya!.name
            : _filters[index];
      case 4:
        return _selectedCommune != null
            ? _selectedCommune!.name
            : _filters[index];
      default:
        return _filters[index];
    }
  }

  void _selectFilter(int index) {
    setState(() {
      _selectedFilterIndex = index;
      _showCategoryOptions = index == 0;
      _showSpecialtyOptions = index == 1 &&
          (_selectedCategory == HealthcareType.medecin ||
              _selectedCategory == HealthcareType.dentiste);
      _showGenderOptions = index == 2;
      _showWilayaOptions = index == 3;
      _showCommuneOptions =
          index == 4 && _selectedWilaya == AlgerianWilayas.alger;

      _removeOverlay();

      if (_showCategoryOptions) {
        _showCategoryOverlay();
      } else if (_showSpecialtyOptions) {
        _showSpecialtyOverlay();
      } else if (_showGenderOptions) {
        _showGenderOverlay();
      } else if (_showWilayaOptions) {
        _showWilayaOverlay();
      } else if (_showCommuneOptions) {
        _showCommuneOverlay();
      }
    });
  }

  Future<void> _toggleFavorite(String professionalId) async {
    if (_currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Veuillez vous connecter pour ajouter aux favoris')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // First check if the patient document exists
      final patientDoc = await FirebaseFirestore.instance
          .collection('users') //mayssa update this when login is fixed
          .doc(_currentUserId)
          .get();

      if (!patientDoc.exists) {
        // Create the patient document if it doesn't exist
        await FirebaseFirestore.instance
            .collection('users') //mayssa update this when login is fixed
            .doc(_currentUserId)
            .set({
          'favoriteHealthcareProfessionals': [],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Now check the favorite status
      final isFavorite = await _patientService.isHealthcareProfessionalFavorite(
        patientId: _currentUserId!,
        professionalId: professionalId,
      );

      if (isFavorite) {
        await _patientService.removeFavoriteHealthcareProfessional(
          patientId: _currentUserId!,
          professionalId: professionalId,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Retiré des favoris')),
        );
      } else {
        await _patientService.addFavoriteHealthcareProfessional(
          patientId: _currentUserId!,
          professionalId: professionalId,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ajouté aux favoris')),
        );
      }

      // Refresh the UI
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showCategoryOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Choisir une catégorie',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Divider(height: 1),
                    ..._categories.map((category) {
                      return ListTile(
                        title: Text(
                            HealthcareProfessional.typeDisplayMap[category]!),
                        trailing: _selectedCategory == category
                            ? Icon(Icons.check, color: primaryColor)
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                            _selectedSpecialty =
                                null; // Reset specialty when category changes
                            _removeOverlay();
                            _searchProfessionals();
                          });
                        },
                      );
                    }).toList(),
                    ListTile(
                      title: Text('Tous'),
                      trailing: _selectedCategory == null
                          ? Icon(Icons.check, color: primaryColor)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedCategory = null;
                          _selectedSpecialty = null;
                          _removeOverlay();
                          _searchProfessionals();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _showSpecialtyOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Choisir une spécialité',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Divider(height: 1),
                    ...Specialty.values.map((specialty) {
                      return ListTile(
                        title: Text(specialty.displayName),
                        trailing: _selectedSpecialty == specialty
                            ? Icon(Icons.check, color: primaryColor)
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedSpecialty = specialty;
                            _removeOverlay();
                            _searchProfessionals();
                          });
                        },
                      );
                    }).toList(),
                    ListTile(
                      title: Text('Tous'),
                      trailing: _selectedSpecialty == null
                          ? Icon(Icons.check, color: primaryColor)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedSpecialty = null;
                          _removeOverlay();
                          _searchProfessionals();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _showGenderOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Choisir un genre',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Divider(height: 1),
                    ..._genders.map((gender) {
                      return ListTile(
                        title: Text(gender == Gender.male ? 'Homme' : 'Femme'),
                        trailing: _selectedGender == gender
                            ? Icon(Icons.check, color: primaryColor)
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedGender = gender;
                            _removeOverlay();
                            _searchProfessionals();
                          });
                        },
                      );
                    }).toList(),
                    ListTile(
                      title: Text('Peu importe'),
                      trailing: _selectedGender == null
                          ? Icon(Icons.check, color: primaryColor)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedGender = null;
                          _removeOverlay();
                          _searchProfessionals();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _showWilayaOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.7),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Choisir une wilaya',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Divider(height: 1),
                        ...AlgerianWilayas.values.map((wilaya) {
                          return ListTile(
                            title: Text(wilaya.name),
                            trailing: _selectedWilaya == wilaya
                                ? Icon(Icons.check, color: primaryColor)
                                : null,
                            onTap: () {
                              setState(() {
                                _selectedWilaya = wilaya;
                                _selectedCommune =
                                    null; // Reset commune when wilaya changes
                                _removeOverlay();
                                _searchProfessionals();
                              });
                            },
                          );
                        }).toList(),
                        ListTile(
                          title: Text('Toutes'),
                          trailing: _selectedWilaya == null
                              ? Icon(Icons.check, color: primaryColor)
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedWilaya = null;
                              _selectedCommune = null;
                              _removeOverlay();
                              _searchProfessionals();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _showCommuneOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Choisir une commune',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Divider(height: 1),
                    ...AlgiersCommunes.values.map((commune) {
                      return ListTile(
                        title: Text(commune.name),
                        trailing: _selectedCommune == commune
                            ? Icon(Icons.check, color: primaryColor)
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedCommune = commune;
                            _removeOverlay();
                            _searchProfessionals();
                          });
                        },
                      );
                    }).toList(),
                    ListTile(
                      title: Text('Toutes'),
                      trailing: _selectedCommune == null
                          ? Icon(Icons.check, color: primaryColor)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedCommune = null;
                          _removeOverlay();
                          _searchProfessionals();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
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
          "Découvrir",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : _professionals.isEmpty
                    ? Center(child: Text('Aucun résultat trouvé'))
                    : _buildProfessionalList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            children: [
              SizedBox(width: 8),
              ...List.generate(_filters.length, (index) {
                // Hide specialty filter if category is not doctor/dentist
                if (index == 1 &&
                    !(_selectedCategory == HealthcareType.medecin ||
                        _selectedCategory == HealthcareType.dentiste)) {
                  return SizedBox.shrink();
                }
                // Hide commune filter if wilaya is not Alger
                if (index == 4 && _selectedWilaya != AlgerianWilayas.alger) {
                  return SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _filterButton(index),
                );
              }),
              SizedBox(width: 8),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey[300]),
      ],
    );
  }

  Widget _filterButton(int index) {
    final isSelected = _selectedFilterIndex == index;
    final buttonText = _getFilterText(index);

    return ElevatedButton(
      onPressed: () => _selectFilter(index),
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black,
        backgroundColor: isSelected ? primaryColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            buttonText,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Icon(
            Icons.arrow_drop_down,
            size: 20,
            color: isSelected ? Colors.white : textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _professionals.length,
      itemBuilder: (context, index) {
        return _buildProfessionalCard(_professionals[index]);
      },
    );
  }

  void _showRatingDialog(
    BuildContext context, HealthcareProfessional professional) {
  double currentRating = professional.rating;
  bool isSubmitting = false;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (dialogContext, setState) { // Use dialogContext here
          return AlertDialog(
            title: Text('Rate ${professional.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Select a rating between 1 and 5 stars'),
                SizedBox(height: 20),
                RatingBar.builder(
                  initialRating: currentRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      currentRating = rating;
                    });
                  },
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
                          // Use dialogContext to access the provider
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
                          _loadProfessionals();
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
                    backgroundImage:
                        NetworkImage(_getProfileImage(professional)),
                  ),
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
                  FutureBuilder<bool>(
                    future: _currentUserId != null
                        ? _patientService.isHealthcareProfessionalFavorite(
                            patientId: _currentUserId!,
                            professionalId: professional.id,
                          )
                        : Future.value(false),
                    builder: (context, snapshot) {
                      final isFavorite = snapshot.data ?? false;
                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? const Color.fromARGB(255, 132, 196, 248)
                              : accentColor,
                        ),
                        onPressed: () => _toggleFavorite(professional.id),
                      );
                    },
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
                              future: RatingService()
                                  .getAverageRating(professional.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text(
                                    '...',
                                    style: TextStyle(color: textColor),
                                  );
                                } else if (snapshot.hasData) {
                                  double rating = snapshot.data!;
                                  return Text(
                                    rating == 0
                                        ? '0'
                                        : rating.toStringAsFixed(1),
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
                        future: _commentService
                            .getCommentCount(professional.id)
                            .then((value) => value ?? 0),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('...',
                                style: TextStyle(color: textColor));
                          } else if (snapshot.hasData) {
                            return Text('${snapshot.data}',
                                style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold));
                          } else {
                            return Text('0',
                                style: TextStyle(color: textColor));
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
                          builder: (context) =>
                              professional.type == HealthcareType.clinique
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
    // Placeholder images based on gender and type
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