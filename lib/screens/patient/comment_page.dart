import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Pour le formatage de date/heure
import '../../../models/Comment_service.dart';
import '../../../models/Comment.dart';

class CommentsPage extends StatefulWidget {
  final String healthcareProfessionalId;
  final String professionalName;

  const CommentsPage({
    required this.healthcareProfessionalId,
    required this.professionalName,
    Key? key,
  }) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  final CommentService _commentService = CommentService();
  List<Comment> _comments = [];
  bool _isLoading = false;

  // Couleurs cohérentes avec DiscoverScreen
  static const Color primaryColor = Color(0xFF396C9B);
  static const Color accentColor = Color.fromARGB(255, 53, 111, 134);
  static const Color textColor = Color.fromARGB(255, 19, 87, 114);
  static const Color cardBackground = Colors.white;
  static const Color dividerColor = Color(0xFFEEEEEE);

  // Formatteur de date et heure
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final DateFormat _timeFormat = DateFormat('HH:mm');

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() => _isLoading = true);
    try {
      final comments = await _commentService.getCommentsForProfessional(
        widget.healthcareProfessionalId,
      );
      setState(() {
        _comments = comments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de chargement des commentaires: $e')),
      );
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vous devez être connecté pour commenter')),
      );
      return;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    final currentUserName = userDoc.data()?['name'] ?? 'Utilisateur';

    final newComment = Comment(
      patientName: currentUserName,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: currentUser.uid,
      healthcareProfessionalId: widget.healthcareProfessionalId,
      comment: _commentController.text,
      date: DateTime.now(),
    );

    setState(() => _isLoading = true);
    try {
      await _commentService.addComment(newComment);
      _commentController.clear();
      await _loadComments();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout du commentaire: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        elevation: 0,
        title: Text(
          'Commentaires - ${widget.professionalName}',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : _comments.isEmpty
                    ? Center(
                        child: Text(
                          'Aucun commentaire pour le moment',
                          style: TextStyle(color: textColor),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          final comment = _comments[index];
                          return _buildCommentCard(comment);
                        },
                      ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildCommentCard(Comment comment) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.2),
                      child: Icon(Icons.person, color: primaryColor),
                    ),
                    SizedBox(width: 12),
                    Text(
                      comment.patientName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _dateFormat.format(comment.date),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      _timeFormat.format(comment.date),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Divider(color: dividerColor, height: 1),
            SizedBox(height: 8),
            Text(
              comment.comment,
              style: TextStyle(color: textColor.withOpacity(0.8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: dividerColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Ajouter un commentaire...',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: dividerColor),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              maxLines: null,
            ),
          ),
          SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _addComment,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}