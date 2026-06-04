import 'package:flutter/material.dart';
import '../data/board_repository.dart';
import 'board_detail_screen.dart';

class BoardListScreen extends StatefulWidget {
  final String boardName;
  final BoardRepository repository;

  const BoardListScreen({super.key, required this.boardName, required this.repository});

  @override
  State<BoardListScreen> createState() => _BoardListScreenState();
}

class _BoardListScreenState extends State<BoardListScreen> {
  void _showCreatePostSheet(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    bool isConcept = widget.boardName == 'Concept';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text('게시글 올리기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    if (widget.boardName != 'Concept')
                      SwitchListTile(
                        title: const Text('개념글로 등록'),
                        value: isConcept,
                        onChanged: (value) => setModalState(() => isConcept = value),
                      ),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: '제목',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: contentController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: '내용',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final title = titleController.text.trim();
                          final content = contentController.text.trim();
                          if (title.isEmpty || content.isEmpty) return;

                          setState(() {
                            widget.repository.addPost(
                              widget.boardName,
                              title,
                              content,
                              concept: isConcept,
                            );
                          });
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFBBF24),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('등록'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final posts = widget.repository.getPosts(widget.boardName);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boardName == 'Concept' ? '개념글 게시판' : '${widget.boardName} 게시판'),
        backgroundColor: const Color(0xFFFBBF24),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePostSheet(context),
        icon: const Icon(Icons.create),
        label: const Text('글 올리기'),
        backgroundColor: const Color(0xFFFBBF24),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (widget.boardName != 'Concept')
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  '수업별 이야기와 질문을 올리고 좋아요와 댓글로 소통해보세요.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
            Expanded(
              child: ListView.separated(
                itemCount: posts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BoardDetailScreen(
                              boardName: widget.boardName,
                              post: post,
                              repository: widget.repository,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
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
                                  child: Text(
                                    post.title,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              post.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('댓글 ${post.comments.length} · 좋아요 ${post.likes}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                Text('작성자 ${post.author}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
