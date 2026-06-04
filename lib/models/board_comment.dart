class BoardComment {
  final String id;
  final String author;
  final String message;
  final DateTime createdAt;
  final List<BoardComment> replies;

  BoardComment({
    required this.id,
    required this.author,
    required this.message,
    required this.createdAt,
    List<BoardComment>? replies,
  }) : replies = replies ?? [];
}
