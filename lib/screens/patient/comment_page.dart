import 'package:flutter/material.dart';
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

    final newComment = Comment(
      patientName: 'currentUserName', // Remplacez par le nom du patient connecté
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: 'currentUserId', // Remplacez par l'ID du patient connecté
      healthcareProfessionalId: widget.healthcareProfessionalId,
      comment: _commentController.text,
      date: DateTime.now(),
    );

    setState(() => _isLoading = true);
    try {
      await _commentService.addComment(newComment);
      _commentController.clear();
      await _loadComments(); // Recharger les commentaires
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout du commentaire: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commentaires - ${widget.professionalName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _comments.isEmpty
                    ? Center(child: Text('Aucun commentaire pour le moment'))
                    : ListView.builder(
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          final comment = _comments[index];
                          return ListTile(
                            title: Text(comment.comment),
                            subtitle: Text(
                              '${comment.date.day}/${comment.date.month}/${comment.date.year}',
                            ),
                          );
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Ajouter un commentaire...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
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