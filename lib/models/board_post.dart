import 'board_comment.dart';

class BoardPost {
  final String id;
  final String boardName;
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;
  final bool concept;
  int likes;
  final List<BoardComment> comments;

  BoardPost({
    required this.id,
    required this.boardName,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    this.concept = false,
    this.likes = 0,
    List<BoardComment>? comments,
  }) : comments = comments ?? [];
}
