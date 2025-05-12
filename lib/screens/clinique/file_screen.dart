import 'package:flutter/material.dart';

// Supprimer la première définition de FilesScreen qui est en double
// et garder uniquement la version StatefulWidget

class Files_clinique extends StatefulWidget {
  @override
  _Files_cliniqueState createState() => _Files_cliniqueState();
}

class _Files_cliniqueState extends State<Files_clinique> {
  int _selectedFilterIndex = 0;
  String? _selectedType;
  String? _selectedDoctor;
  String? _selectedOrder;
  OverlayEntry? _overlayEntry;
  Set<String> _savedFiles = {};

  static const Color textColor = Color.fromARGB(255, 19, 87, 114);
  static const Color primaryColor = Color(0xFF396C9B);
  static const Color myDarkBlue = Color(0xFF073057);
  static const Color myBlue2 = Color(0xFF396C9B);
  static const Color myLightBlue = Color(0xFFA3C3E4);

  final List<String> _filters = ['Type', 'Patient', 'Ordre'];
  final List<String> _types = ['Tous', 'PDF', 'JPG', 'PNG', 'DOCX'];
  final List<String> _doctors = [
    'Tous',
    'Benbrika Younes',
    'Ben Slimane Ahmed',
    'Khiari Anis',
    'Araar Nour',
    'Charif Maysaa',
  ];
  final List<String> _orders = [
    'Aléatoire',
    'A-Z',
    'Z-A',
    'Plus récent',
    'Plus ancien',
  ];

  final List<Map<String, String>> files = [
    {
      "type": "PDF",
      "name": "Compte_rendu_IRM.pdf",
      "doctor": "Benbrika Younes",
      "date": "02/02/2025",
    },
    {
      "type": "PDF",
      "name": "Rapport_Bilan_2025.pdf",
      "doctor": "Ben Slimane Ahmed",
      "date": "10/02/2025",
    },
    {
      "type": "PDF",
      "name": "Analyse_Sang.pdf",
      "doctor": "Khiari Anis",
      "date": "03/02/2025",
    },
    {
      "type": "JPG",
      "name": "Ordonnance_2025.jpg",
      "doctor": "Araar Nour",
      "date": "28/01/2025",
    },
    {
      "type": "PNG",
      "name": "Radio.png",
      "doctor": "Charif Maysaa",
      "date": "15/01/2025",
    },
  ];

  void _toggleSaveFile(String fileName) {
    setState(() {
      if (_savedFiles.contains(fileName)) {
        _savedFiles.remove(fileName);
      } else {
        _savedFiles.add(fileName);
      }
    });
  }

  String get _activeFilterText {
    if (_selectedFilterIndex == 0 && _selectedType != null) {
      return _selectedType!;
    } else if (_selectedFilterIndex == 1 && _selectedDoctor != null) {
      return _selectedDoctor!;
    } else if (_selectedFilterIndex == 2 && _selectedOrder != null) {
      return _selectedOrder!;
    }
    return _filters[_selectedFilterIndex];
  }

  void _selectFilter(int index) {
    setState(() {
      _selectedFilterIndex = index;
      _removeOverlay();

      if (index == 0) {
        _showTypeOverlay();
      } else if (index == 1) {
        _showDoctorOverlay();
      } else if (index == 2) {
        _showOrderOverlay();
      }
    });
  }

  void _showTypeOverlay() {
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
                            'Filtrer par type',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Divider(height: 1),
                        ..._types.map((type) {
                          return ListTile(
                            title: Text(type),
                            trailing:
                                _selectedType == type
                                    ? Icon(Icons.check, color: primaryColor)
                                    : null,
                            onTap: () {
                              setState(() {
                                _selectedType = type;
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

  void _showDoctorOverlay() {
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
                            'Filtrer par patient',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Divider(height: 1),
                        ..._doctors.map((doctor) {
                          return ListTile(
                            title: Text(doctor),
                            trailing:
                                _selectedDoctor == doctor
                                    ? Icon(Icons.check, color: primaryColor)
                                    : null,
                            onTap: () {
                              setState(() {
                                _selectedDoctor = doctor;
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

  void _showOrderOverlay() {
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
                            'Trier par',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Divider(height: 1),
                        ..._orders.map((order) {
                          return ListTile(
                            title: Text(order),
                            trailing:
                                _selectedOrder == order
                                    ? Icon(Icons.check, color: primaryColor)
                                    : null,
                            onTap: () {
                              setState(() {
                                _selectedOrder = order;
                                _removeOverlay();
                                _applyOrder();
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

  void _applyOrder() {
    switch (_selectedOrder) {
      case 'A-Z':
        files.sort((a, b) => a['name']!.compareTo(b['name']!));
        break;
      case 'Z-A':
        files.sort((a, b) => b['name']!.compareTo(a['name']!));
        break;
      case 'Plus récent':
        files.sort(
          (a, b) => _parseDate(b['date']!).compareTo(_parseDate(a['date']!)),
        );
        break;
      case 'Plus ancien':
        files.sort(
          (a, b) => _parseDate(a['date']!).compareTo(_parseDate(b['date']!)),
        );
        break;
      case 'Aléatoire':
        files.shuffle();
        break;
    }
    setState(() {});
  }

  DateTime _parseDate(String dateStr) {
    final parts = dateStr.split('/');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
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
          'Mes Fichiers',
          style: TextStyle(
            color: myDarkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [_buildFilters(), Expanded(child: _buildFileList())],
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
        index == 0 && _selectedType != null
            ? _selectedType!
            : index == 1 && _selectedDoctor != null
            ? _selectedDoctor!
            : index == 2 && _selectedOrder != null
            ? _selectedOrder!
            : _filters[index];

    return ElevatedButton(
      onPressed: () => _selectFilter(index),
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : textColor,
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
            color: isSelected ? Colors.white : textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildFileList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: files.length,
      itemBuilder: (context, index) {
        return _buildFileCard(files[index]);
      },
    );
  }

  Widget _buildFileCard(Map<String, String> file) {
    bool isSaved = _savedFiles.contains(file['name']);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.insert_drive_file, size: 40, color: primaryColor),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file['name']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        file['doctor']!,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? primaryColor : textColor,
                  ),
                  onPressed: () => _toggleSaveFile(file['name']!),
                ),
                PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: textColor),
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.download, color: textColor),
                              SizedBox(width: 8),
                              Text('Télécharger'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.share, color: textColor),
                              SizedBox(width: 8),
                              Text('Partager'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Supprimer'),
                            ],
                          ),
                        ),
                      ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  file['date']!,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
