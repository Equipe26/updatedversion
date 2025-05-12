import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'chat_screen.dart';
import '../../../models/UserService.dart';
import '../../../models/MessagingService.dart';
import '../../../models/User.dart' as app_models;
import '../../../login/connexion.dart';

class NewMessageScreen extends StatefulWidget {
  const NewMessageScreen({super.key});

  @override
  State<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<app_models.User> _allUsers = [];
  List<app_models.User> _filteredUsers = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllUsers();
    });
    _searchController.addListener(_filterUsers);
  }

 Future<void> _loadAllUsers() async {
  try {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
      return;
    }

    final userService = Provider.of<UserService>(context, listen: false);
    final users = await userService.getAllUsers();
    
    if (mounted) {
      setState(() {
        _allUsers = users.where((user) => user.id != currentUser.uid).toList();
        _filteredUsers = List.from(_allUsers);
        _isLoading = false;
      });
    }
  } catch (e, stackTrace) {
    debugPrint('Error loading users: $e');
    debugPrint('Stack trace: $stackTrace');
    if (mounted) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }
}

 void _filterUsers() {
  final query = _searchController.text.trim().toLowerCase();
  setState(() {
    _filteredUsers = query.isEmpty
        ? List.from(_allUsers)
        : _allUsers.where((user) {
            final name = user.name.toLowerCase();
            final email = user.email.toLowerCase();
            return name.contains(query) || email.contains(query);
          }).toList();
  });
}
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7ECFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA3C3E4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF073057)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New Message',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF073057),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading users',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAllUsers,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by name or email...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF073057)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        Expanded(
          child: _filteredUsers.isEmpty
              ? Center(
                  child: Text(
                    _searchController.text.isEmpty
                        ? 'No users available'
                        : 'No results found',
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = _filteredUsers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(user.name.isNotEmpty
                            ? user.name[0].toUpperCase()
                            : '?'),
                      ),
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => _startConversation(context, user),
                    );
                  },
                ),
        ),
      ],
    );
  }

Future<void> _startConversation(BuildContext context, app_models.User otherUser) async {
  try {
    final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception('Not authenticated');

    final messagingService = Provider.of<MessagingService>(context, listen: false);
    
    // 1. Créer ou obtenir une connection entre les utilisateurs
    final connectionId = await messagingService.getOrCreateConnection(
      currentUser.uid,
      otherUser.id,
    );
    
    // 2. Créer ou obtenir une conversation pour cette connection
    final conversationId = await messagingService.getOrCreateConversation(connectionId);
    
    if (!mounted) return;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          connectionId: connectionId, // Ajoutez ce paramètre
          conversationId: conversationId,
          otherParticipant: {
            'id': otherUser.id,
            'name': otherUser.name,
            'email': otherUser.email,
          },
        ),
      ),
    );
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
    debugPrint('Error starting conversation: $e');
  }
}

  @override
  void dispose() {
    _searchController.removeListener(_filterUsers);
    _searchController.dispose();
    super.dispose();
  }
}