import 'package:flutter/material.dart';

class Serviceclinique extends StatefulWidget {
  @override
  _ServicecliniqueState createState() => _ServicecliniqueState();
}

class _ServicecliniqueState extends State<Serviceclinique> {
  int _selectedFilterIndex = 0;
  String? _selectedCategory;
  String? _selectedSpecialty;
  String? _selectedGender;
  bool _showCategoryOptions = false;
  bool _showSpecialtyOptions = false;
  bool _showGenderOptions = false;
  OverlayEntry? _overlayEntry;
  Map<String, bool> _favorites = {};

  static const Color textColor = Color.fromARGB(255, 19, 87, 114);
  static const Color primaryColor = Color(0xFF396C9B);
  static const Color newcol = Color.fromARGB(255, 53, 111, 134);
  final List<String> _filters = ['Catégorie', 'Spécialité', 'Sexe'];
  final List<String> _categories = [
    'Tous',
    'Médecins',
    'Infirmiers',
    'Pharmacies',
    'Cliniques',
    'Centres d\'imagerie',
    'Laboratoires d\'analyse',
  ];
  final List<String> _specialties = [
    'Tous',
    'Généraliste',
    'Dentiste',
    'Cardiologue',
    'Pédiatre',
    'Dermatologue',
  ];
  final List<String> _genders = ['Homme', 'Femme', 'Peu importe'];

  final List<Map<String, dynamic>> _services = [
    {
      "name": "Dr. Boudaoud Athmane",
      "type": "Médecine interne",
      "image":
          "https://th.bing.com/th/id/OIP.ftpyW0_ODpuiXjJl2EFj-AAAAA?w=474&h=474&rs=1&pid=ImgDetMain",
      "rating": 4.8,
      "reviews": 124,
      "isFavorite": false,
    },
    {
      "name": "Pharmacie Sayad",
      "type": "",
      "image":
          "https://th.bing.com/th/id/R.dc468394184b1fa1283265fdbfe13bea?rik=l98bV4%2fZVlc90g&pid=ImgRaw&r=0",
      "rating": 4.5,
      "reviews": 86,
      "isFavorite": false,
    },
    {
      "name": "Dr. Khiat Nadjia",
      "type": "Stomatologie",
      "image":
          "https://static.vecteezy.com/system/resources/previews/027/546/977/large_2x/doctor-lady-friendly-smiling-arms-crossed-free-photo.jpg",
      "rating": 4.9,
      "reviews": 215,
      "isFavorite": false,
    },
    {
      "name": "Laboratoire Al-Kawthar",
      "type": "",
      "image":
          "https://th.bing.com/th/id/OIP.l2r_Mhu-whNk35KyQRjThAHaE0?w=1200&h=782&rs=1&pid=ImgDetMain",
      "rating": 4.3,
      "reviews": 67,
      "isFavorite": false,
    },
    {
      "name": "Clinique Al Azhar",
      "type": "",
      "image":
          "https://th.bing.com/th/id/OIP.gOuhVEh3sz8fFlTESzmlcgAAAA?rs=1&pid=ImgDetMain",
      "rating": 4.7,
      "reviews": 342,
      "isFavorite": false,
    },
  ];

  String get _activeFilterText {
    if (_selectedFilterIndex == 0 && _selectedCategory != null) {
      return _selectedCategory!;
    } else if (_selectedFilterIndex == 1 && _selectedSpecialty != null) {
      return _selectedSpecialty!;
    } else if (_selectedFilterIndex == 2 && _selectedGender != null) {
      return _selectedGender!;
    }
    return _filters[_selectedFilterIndex];
  }

  void _selectFilter(int index) {
    setState(() {
      _selectedFilterIndex = index;
      _showCategoryOptions = index == 0;
      _showSpecialtyOptions = index == 1 && _selectedCategory == 'Médecins';
      _showGenderOptions = index == 2;

      _removeOverlay();

      if (_showCategoryOptions) {
        _showCategoryOverlay();
      } else if (_showSpecialtyOptions) {
        _showSpecialtyOverlay();
      } else if (_showGenderOptions) {
        _showGenderOverlay();
      }
    });
  }

  void _toggleFavorite(String serviceName) {
    setState(() {
      _favorites[serviceName] = !(_favorites[serviceName] ?? false);
    });
  }

  void _showCategoryOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder:
          (context) => GestureDetector(
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
                            title: Text(category),
                            trailing:
                                _selectedCategory == category
                                    ? Icon(Icons.check, color: primaryColor)
                                    : null,
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                                _removeOverlay();
                              });
                            },
                          );
                        }).toList(),
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
      builder:
          (context) => GestureDetector(
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
                        ..._specialties.map((specialty) {
                          return ListTile(
                            title: Text(specialty),
                            trailing:
                                _selectedSpecialty == specialty
                                    ? Icon(Icons.check, color: primaryColor)
                                    : null,
                            onTap: () {
                              setState(() {
                                _selectedSpecialty = specialty;
                                _removeOverlay();
                              });
                            },
                          );
                        }).toList(),
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
      builder:
          (context) => GestureDetector(
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
                            title: Text(gender),
                            trailing:
                                _selectedGender == gender
                                    ? Icon(Icons.check, color: primaryColor)
                                    : null,
                            onTap: () {
                              setState(() {
                                _selectedGender = gender;
                                _removeOverlay();
                              });
                            },
                          );
                        }).toList(),
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
          "Découvrir nos services",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [_buildFilters(), Expanded(child: _buildServiceList())],
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
                if (index == 1 && _selectedCategory != 'Médecins') {
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
    final buttonText =
        index == 0 && _selectedCategory != null
            ? _selectedCategory!
            : index == 1 && _selectedSpecialty != null
            ? _selectedSpecialty!
            : index == 2 && _selectedGender != null
            ? _selectedGender!
            : _filters[index];

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
          Text(buttonText, overflow: TextOverflow.ellipsis, maxLines: 1),
          Icon(
            Icons.arrow_drop_down,
            size: 20,
            color:
                isSelected
                    ? Colors.white
                    : textColor, // Utilisation de textColor
          ),
        ],
      ),
    );
  }

  Widget _buildServiceList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _services.length,
      itemBuilder: (context, index) {
        return _buildServiceCard(_services[index]);
      },
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    bool isFavorite = _favorites[service['name']] ?? false;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(service['image']),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (service['type'].isNotEmpty)
                        Text(
                          service['type'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color:
                        isFavorite
                            ? const Color.fromARGB(255, 132, 196, 248)
                            : newcol,
                  ),
                  onPressed: () => _toggleFavorite(service['name']),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: newcol, size: 18),
                    SizedBox(width: 4),
                    Text(
                      service['rating'].toString(),
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.comment, color: newcol, size: 18),
                    SizedBox(width: 4),
                    Text(
                      service['reviews'].toString(),
                      style: TextStyle(color: textColor),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.info_outline, color: newcol),
                  onPressed: () {
                    // Action pour "En savoir plus"
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
