import 'package:flutter/material.dart';
import 'admin_service.dart';
import '../models/HealthcareProfessional.dart';

class AdminUsers extends StatefulWidget {
  @override
  _AdminUsersState createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> with SingleTickerProviderStateMixin {
  final AdminService _adminService = AdminService();
  bool _isLoading = false;
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String _selectedRole = 'all'; // 'all', 'patient', 'hp'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _selectedRole = 'all';
            break;
          case 1:
            _selectedRole = 'patient';
            break;
          case 2:
            _selectedRole = 'hp';
            break;
        }
        _filterUsers();
      });
    }
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final users = await _adminService.getAllUsers();
      setState(() {
        _allUsers = users;
        _filterUsers();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des utilisateurs: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterUsers() {
    final searchQuery = _searchController.text.toLowerCase();
    
    setState(() {
      _filteredUsers = _allUsers.where((user) {
        final nameMatches = user['name']?.toString().toLowerCase().contains(searchQuery) ?? false;
        final emailMatches = user['email']?.toString().toLowerCase().contains(searchQuery) ?? false;
        final roleMatches = _selectedRole == 'all' || user['role'] == _selectedRole;
        
        return (nameMatches || emailMatches) && roleMatches;
      }).toList();
    });
  }

  // Delete user method
  Future<void> _deleteUser(String userId, String userName) async {
    // Show confirmation dialog first
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer l\'utilisateur "$userName" ? Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Supprimer'),
          ),
        ],
      ),
    ) ?? false;

    if (!confirmDelete) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _adminService.deleteUser(userId);
      
      // Remove user from local lists
      setState(() {
        _allUsers.removeWhere((user) => user['id'] == userId);
        _filteredUsers.removeWhere((user) => user['id'] == userId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Utilisateur supprimé avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA3C3E4),
        elevation: 0,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.people, color: Color(0xFF073057)),
              SizedBox(width: 10),
              Text(
                'Utilisateurs',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF073057),
                ),
              ),
            ],
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xFF073057),
          unselectedLabelColor: Colors.black54,
          indicatorColor: Color(0xFF073057),
          tabs: [
            Tab(text: 'Tous'),
            Tab(text: 'Patients'),
            Tab(text: 'Prof. de santé'),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => _filterUsers(),
                  decoration: InputDecoration(
                    hintText: 'Rechercher un utilisateur...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              SizedBox(height: 16),
              
              // User list
              Expanded(
                child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _filteredUsers.isEmpty
                    ? Center(
                        child: Text(
                          'Aucun utilisateur trouvé',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = _filteredUsers[index];
                          return _buildUserCard(user);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final bool isHealthcareProfessional = user['role'] == 'hp';
    final String userType = isHealthcareProfessional 
      ? _getHealthcareTypeDisplay(user['type']) 
      : 'Patient';
    
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: isHealthcareProfessional ? Color(0xFF396C9B) : Color(0xFF73AEF5),
          radius: 25,
          child: Icon(
            isHealthcareProfessional ? Icons.medical_services : Icons.person,
            color: Colors.white,
          ),
        ),
        title: Text(
          user['name'] ?? 'Sans nom',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              user['email'] ?? 'Email inconnu',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isHealthcareProfessional ? Color(0xFF396C9B) : Color(0xFF73AEF5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    userType,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                if (isHealthcareProfessional) ...[
                  SizedBox(width: 8),
                  _buildValidationBadge(user),
                ],
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.info_outline, color: Color(0xFF396C9B)),
          onPressed: () => _showUserDetails(user),
        ),
        onTap: () => _showUserDetails(user),
      ),
    );
  }

  Widget _buildValidationBadge(Map<String, dynamic> user) {
    final bool isValidated = user['isValidatedByAdmin'] == true;
    final bool isDenied = user['isDeniedByAdmin'] == true;
    
    Color badgeColor;
    String badgeText;
    IconData badgeIcon;
    
    if (isValidated) {
      badgeColor = Colors.green;
      badgeText = 'Validé';
      badgeIcon = Icons.check_circle;
    } else if (isDenied) {
      badgeColor = Colors.red;
      badgeText = 'Refusé';
      badgeIcon = Icons.cancel;
    } else {
      badgeColor = Colors.orange;
      badgeText = 'En attente';
      badgeIcon = Icons.hourglass_top;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, color: Colors.white, size: 12),
          SizedBox(width: 4),
          Text(
            badgeText,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showUserDetails(Map<String, dynamic> user) {
    final bool isHealthcareProfessional = user['role'] == 'hp';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user['name'] ?? 'Détails utilisateur'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Email: ${user['email'] ?? 'Non disponible'}'),
              SizedBox(height: 8),
              Text('Type: ${isHealthcareProfessional ? _getHealthcareTypeDisplay(user['type']) : 'Patient'}'),
              SizedBox(height: 8),
              Text('Location: ${user['location'] ?? 'Non disponible'}'),
              
              if (isHealthcareProfessional) ...[
                SizedBox(height: 8),
                Text('Spécialité: ${_getSpecialtyDisplay(user)}'),
                SizedBox(height: 8),
                Text('Numéro de licence: ${user['licenseNumber'] ?? 'Non disponible'}'),
                SizedBox(height: 8),
                Text('Statut de validation: ${user['isValidatedByAdmin'] == true ? 'Validé' : (user['isDeniedByAdmin'] == true ? 'Refusé' : 'En attente')}'),
              ],
              
              if (!isHealthcareProfessional) ...[
                SizedBox(height: 8),
                Text('Rendez-vous: ${user['appointmentIds']?.length ?? 0}'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fermer'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteUser(user['id'], user['name'] ?? 'Cet utilisateur');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete, size: 16),
                SizedBox(width: 4),
                Text('Supprimer'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getHealthcareTypeDisplay(String? typeString) {
    if (typeString == null) return 'Non spécifié';
    
    try {
      final type = HealthcareType.values.firstWhere(
        (e) => e.name == typeString,
        orElse: () => HealthcareType.medecin,
      );
      return HealthcareProfessional.typeDisplayMap[type] ?? type.name;
    } catch (e) {
      return typeString;
    }
  }

  String _getSpecialtyDisplay(Map<String, dynamic> user) {
    final specialty = user['specialty'];
    if (specialty == null) return 'Non spécifiée';
    return specialty;
  }
}