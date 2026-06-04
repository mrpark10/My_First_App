import 'package:flutter/material.dart';
import '../data/board_repository.dart';
import '../models/board_post.dart';

class BoardDetailScreen extends StatefulWidget {
  final String boardName;
  final BoardPost post;
  final BoardRepository repository;

  const BoardDetailScreen({super.key, required this.boardName, required this.post, required this.repository});

  @override
  State<BoardDetailScreen> createState() => _BoardDetailScreenState();
}

class _BoardDetailScreenState extends State<BoardDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final Map<String, TextEditingController> _replyControllers = {};
  String? _replyTargetId;
  bool _liked = false;

  @override
  void dispose() {
    _commentController.dispose();
    for (final controller in _replyControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      widget.repository.toggleLike(widget.boardName, widget.post.id, _liked);
    });
  }

  void _addComment([String? parentCommentId]) {
    final controller = parentCommentId == null ? _commentController : _replyControllers[parentCommentId];
    if (controller == null) return;

    final text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      widget.repository.addComment(widget.boardName, widget.post.id, text, parentCommentId: parentCommentId);
      controller.clear();
      _replyTargetId = null;
    });
  }

  void _toggleReplyField(String commentId) {
    setState(() {
      if (_replyTargetId == commentId) {
        _replyTargetId = null;
      } else {
        _replyTargetId = commentId;
        _replyControllers.putIfAbsent(commentId, () => TextEditingController());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.repository.getPosts(widget.boardName).firstWhere((item) => item.id == widget.post.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
        backgroundColor: const Color(0xFFFBBF24),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (post.concept)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('개념글', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        if (post.concept) const SizedBox(width: 8),
                        Expanded(
                          child: Text(post.boardName == 'Concept' ? '개념글 게시판' : '${post.boardName} 게시판', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(post.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(post.content, style: const TextStyle(fontSize: 16, height: 1.5)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('작성자 ${post.author}', style: const TextStyle(color: Colors.grey)),
                        Text('${post.comments.length} 댓글', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _toggleLike,
                          icon: Icon(
                            _liked ? Icons.favorite : Icons.favorite_border,
                            color: _liked ? Colors.redAccent : Colors.grey[700],
                          ),
                        ),
                        Text('${post.likes} 좋아요', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: post.comments.isEmpty
                  ? const Center(child: Text('첫 댓글을 남겨보세요.', style: TextStyle(color: Colors.grey)))
                  : ListView.separated(
                      itemCount: post.comments.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final comment = post.comments[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF8E7),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(comment.author, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      Text(
                                        '${comment.createdAt.hour.toString().padLeft(2, '0')}:${comment.createdAt.minute.toString().padLeft(2, '0')}',
                                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(comment.message),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () => _toggleReplyField(comment.id),
                                        child: const Text('답글'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (comment.replies.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 16, top: 8),
                                child: Column(
                                  children: comment.replies.map((reply) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFFFFF),
                                          borderRadius: BorderRadius.circular(14),
                                          border: Border.all(color: const Color(0xFFEDE3C5)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(reply.author, style: const TextStyle(fontWeight: FontWeight.bold)),
                                                Text(
                                                  '${reply.createdAt.hour.toString().padLeft(2, '0')}:${reply.createdAt.minute.toString().padLeft(2, '0')}',
                                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(reply.message),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            if (_replyTargetId == comment.id)
                              Padding(
                                padding: const EdgeInsets.only(left: 16, top: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _replyControllers[comment.id],
                                        decoration: InputDecoration(
                                          hintText: '답글을 입력하세요',
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    IconButton(
                                      onPressed: () => _addComment(comment.id),
                                      icon: const Icon(Icons.send, color: Color(0xFFFBBF24)),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _addComment(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBBF24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  ),
                  child: const Text('댓글'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
