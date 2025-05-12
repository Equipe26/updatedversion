import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/HealthcareProfessional.dart';
import 'package:flutter_application_2/models/HealthcareProfessionalService.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/MedicalDocument.dart';
import '../../models/MedicalDocumentService.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FilesScreen(),
    );
  }
}

class FilesScreen extends StatefulWidget {
  @override
  _FilesScreenState createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  late HealthcareProfessionalService _healthcareProfessionalService;
  List<String> _doctors = ['Tous']; // Initialisation avec 'Tous'
  int _selectedFilterIndex = 0;
  String? _selectedType;
  String? _selectedDoctor;
  String? _selectedOrder;
  OverlayEntry? _overlayEntry;
  Set<String> _savedFiles = {};
  late MedicalDocumentService _documentService;
  List<MedicalDocument> _documents = [];
  bool _isLoading = true;
  String? _error;

  static const Color textColor = Color.fromARGB(255, 19, 87, 114);
  static const Color primaryColor = Color(0xFF396C9B);

  final List<String> _filters = ['Type', 'Médecin', 'Ordre'];
  final List<String> _types = ['Tous', 'PDF', 'JPG', 'PNG', 'DOCX'];
  final List<String> _orders = [
    'Aléatoire',
    'A-Z',
    'Z-A',
    'Plus récent',
    'Plus ancien'
  ];

  @override
  void initState() {
    super.initState();
    _documentService = MedicalDocumentService();
    _healthcareProfessionalService = HealthcareProfessionalService();
    _loadData(); // Nouvelle méthode combinée
  }
  Future<void> _loadData() async {
    await Future.wait([
      _loadDocuments(),
      _loadHealthcareProfessionals(),
    ]);
  }

  Future<void> _loadHealthcareProfessionals() async {
    try {
      final professionals = await _healthcareProfessionalService.getAll();
      if (!mounted) return;

      // Extraire les noms des médecins
      final doctorNames = professionals
          .where((p) => p.type == HealthcareType.medecin) // Filtrer seulement les médecins si besoin
          .map((p) => p.name)
          .toList();

      setState(() {
        _doctors = ['Tous', ...doctorNames];
        print('Médecins chargés: $_doctors'); // Debug
      });
    } catch (e) {
      print('Erreur chargement médecins: $e');
      if (!mounted) return;
      setState(() {
        _doctors = ['Tous']; // Fallback
      });
    }
  }


  List<MedicalDocument> _allDocuments = [];

  Future<void> _loadDocuments() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final documents = await _documentService.getPatientDocuments(user.uid);

        if (!mounted) return;

        // Extract unique doctors from documents and remove any null values
        final doctorsSet = documents
            .map((doc) => doc.healthcareProfessionalId)
            .where((doctor) => doctor != null && doctor.isNotEmpty)
            .toSet()
            .toList();

        if (!mounted) return;

        setState(() {
          _allDocuments = documents;
          _documents = documents;
          _doctors = ['Tous', ...doctorsSet]; // Update doctors list
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load documents: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _toggleSaveFile(String fileName) {
    if (!mounted) return;
    setState(() {
      if (_savedFiles.contains(fileName)) {
        _savedFiles.remove(fileName);
      } else {
        _savedFiles.add(fileName);
      }
    });
  }

  String get _activeFilterText {
    switch (_selectedFilterIndex) {
      case 0:
        return _selectedType ?? _filters[0];
      case 1:
        return _selectedDoctor ?? _filters[1];
      case 2:
        return _selectedOrder ?? _filters[2];
      default:
        return _filters[_selectedFilterIndex];
    }
  }

  void _selectFilter(int index) {
    if (!mounted) return;
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
                        trailing: _selectedType == type
                            ? Icon(Icons.check, color: primaryColor)
                            : null,
                        onTap: () {
                          if (!mounted) return;
                          setState(() {
                            _selectedType = type == 'Tous' ? null : type;
                            _removeOverlay();
                            _applyFilters();
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
                  maxHeight: MediaQuery.of(context).size.height * 0.7, // 70% de la hauteur d'écran
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Filtrer par médecin',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Divider(height: 1),
                    Expanded( // Ajouté pour le scrolling
                      child: SingleChildScrollView( // Enable scrolling
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: _doctors.map((doctor) {
                            return ListTile(
                              title: Text(doctor),
                              trailing: _selectedDoctor == doctor
                                  ? Icon(Icons.check, color: primaryColor)
                                  : null,
                              onTap: () {
                                if (!mounted) return;
                                setState(() {
                                  _selectedDoctor = doctor == 'Tous' ? null : doctor;
                                  _removeOverlay();
                                  _applyFilters();
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
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

  void _showOrderOverlay() {
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
                        trailing: _selectedOrder == order
                            ? Icon(Icons.check, color: primaryColor)
                            : null,
                        onTap: () {
                          if (!mounted) return;
                          setState(() {
                            _selectedOrder = order;
                            _removeOverlay();
                            _applyFilters();
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

  void _applyFilters() {
    if (!mounted) return;
    
    List<MedicalDocument> filteredDocuments = [..._allDocuments];

    if (_selectedType != null && _selectedType != 'Tous') {
      filteredDocuments = filteredDocuments.where((doc) {
        final fileExt = doc.documentName?.split('.').last.toLowerCase() ??
            doc.type.toLowerCase();
        return fileExt == _selectedType!.toLowerCase();
      }).toList();
    }

    if (_selectedDoctor != null && _selectedDoctor != 'Tous') {
      filteredDocuments = filteredDocuments
          .where((doc) => doc.healthcareProfessionalId == _selectedDoctor)
          .toList();
    }

    if (_selectedOrder != null) {
      switch (_selectedOrder) {
        case 'A-Z':
          filteredDocuments.sort((a, b) =>
              (a.documentName ?? a.id).compareTo(b.documentName ?? b.id));
          break;
        case 'Z-A':
          filteredDocuments.sort((a, b) =>
              (b.documentName ?? b.id).compareTo(a.documentName ?? a.id));
          break;
        case 'Plus récent':
          filteredDocuments
              .sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
          break;
        case 'Plus ancien':
          filteredDocuments
              .sort((a, b) => a.uploadDate.compareTo(b.uploadDate));
          break;
        case 'Aléatoire':
          filteredDocuments.shuffle();
          break;
      }
    }

    setState(() {
      _documents = filteredDocuments;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _shareDocument(MedicalDocument document) async {
    try {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 10),
              Text('Preparing document for sharing...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      final url = await _documentService.getDocumentUrl(document.id);
      final fileName =
          document.documentName ?? url.split('/').last.split('?').first;

      if (Platform.isAndroid || Platform.isIOS) {
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/$fileName';
        final file = await _documentService.downloadDocumentToDevice(
            document.id, filePath);

        if (!mounted) return;
       /* await Share.shareFiles(
          [file.path],
          text:
              'Medical document: ${document.documentName ?? 'Medical Report'}',
          subject: 'Shared medical document',
        );*/
        
      } else {
        if (!mounted) return;
        await Share.share(
          'Medical document: ${document.documentName ?? 'Medical Report'}\n\n'
          'View or download: $url',
          subject: 'Shared medical document',
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to share document: ${e.toString()}'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _deleteDocument(MedicalDocument document) async {
    try {
      await _documentService.deleteDocument(document.id);
      if (!mounted) return;
      setState(() {
        _documents.removeWhere((doc) => doc.id == document.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Document deleted successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: ${e.toString()}')),
      );
    }
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
          "Mes fichiers",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilters(),
          if (_isLoading)
            Expanded(child: Center(child: CircularProgressIndicator())),
          if (_error != null) Expanded(child: Center(child: Text(_error!))),
          if (!_isLoading && _error == null) Expanded(child: _buildFileList()),
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

  Future<void> _downloadDocument(MedicalDocument document) async {
    try {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 10),
              Text('Preparing download...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      if (Platform.isAndroid || Platform.isIOS) {
        final directory = await getExternalStorageDirectory();
        final filePath =
            '${directory?.path}/${document.documentName ?? 'document_${document.id.substring(0, 6)}'}';

        final downloadedFile = await _documentService.downloadDocumentToDevice(
            document.id, filePath);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Downloaded to ${downloadedFile.path}'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        final url = await _documentService.getDocumentUrl(document.id);
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          if (!mounted) return;
          throw 'Could not launch $url';
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: ${e.toString()}'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _filterButton(int index) {
    final isSelected = _selectedFilterIndex == index;
    final hasActiveFilter = (index == 0 && _selectedType != null) ||
        (index == 1 && _selectedDoctor != null) ||
        (index == 2 && _selectedOrder != null);

    return ElevatedButton(
      onPressed: () => _selectFilter(index),
      style: ElevatedButton.styleFrom(
        foregroundColor:
            isSelected || hasActiveFilter ? Colors.white : textColor,
        backgroundColor:
            isSelected || hasActiveFilter ? primaryColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: hasActiveFilter ? primaryColor : Colors.grey[300]!,
            width: hasActiveFilter ? 2 : 1,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            index == 0
                ? (_selectedType ?? _filters[0])
                : index == 1
                    ? (_selectedDoctor ?? _filters[1])
                    : (_selectedOrder ?? _filters[2]),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Icon(
            Icons.arrow_drop_down,
            size: 20,
            color: isSelected || hasActiveFilter ? Colors.white : textColor,
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    if (!mounted) return;
    setState(() {
      _selectedType = null;
      _selectedDoctor = null;
      _selectedOrder = null;
      _applyFilters();
    });
  }

  Widget _buildFileList() {
    if (_documents.isEmpty) {
      return Center(
        child: Text(
          'Aucun document trouvé',
          style: TextStyle(color: Colors.grey, fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _documents.length,
      itemBuilder: (context, index) {
        return _buildFileCard(_documents[index]);
      },
    );
  }

  Widget _buildFileCard(MedicalDocument document) {
    bool isSaved = _savedFiles.contains(document.id);
    final formattedDate = DateFormat('dd/MM/yyyy').format(document.uploadDate);
    final fileName =
        document.documentName ?? 'Document ${document.id.substring(0, 6)}';
    final fileType = document.type.toUpperCase();

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
                        fileName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        document.healthcareProfessionalId,
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
                  onPressed: () => _toggleSaveFile(document.id),
                ),
                PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: textColor),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.download, color: textColor),
                          SizedBox(width: 8),
                          Text('Télécharger'),
                        ],
                      ),
                      onTap: () => _downloadDocument(document),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.share, color: textColor),
                          SizedBox(width: 8),
                          Text('Partager'),
                        ],
                      ),
                      onTap: () => _shareDocument(document),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Supprimer'),
                        ],
                      ),
                      onTap: () => _deleteDocument(document),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  fileType,
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