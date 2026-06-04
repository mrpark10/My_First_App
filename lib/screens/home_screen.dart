// 메인 화면 한 페이지.
// StatusBar / EmojiVote / LiveBoard 세 위젯을 위에서 아래로 쌓습니다.
// 데이터는 MoodRepository 한 곳에서 관리하고, 버튼이 눌리면 setState 로 갱신.

import 'package:flutter/material.dart';
import '../data/board_repository.dart';
import '../data/mood_repository.dart';
import '../screens/board_list_screen.dart';
import '../screens/gallery_screen.dart';
import '../widgets/emoji_vote.dart';
import '../widgets/live_board.dart';
import '../widgets/status_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MoodRepository _moodRepo = MoodRepository();
  final BoardRepository _boardRepo = BoardRepository();
  String _selectedEmoji = '';

  void _onVote(String emoji) {
    setState(() {
      if (_selectedEmoji == emoji) {
        _moodRepo.removeVote(emoji);
        _selectedEmoji = '';
      } else {
        if (_selectedEmoji.isNotEmpty) {
          _moodRepo.removeVote(_selectedEmoji);
        }
        _moodRepo.addVote(emoji);
        _selectedEmoji = emoji;
      }
    });
  }

  void _onSendMessage(String text) {
    setState(() => _moodRepo.addMessage(text));
  }

  void _openBoard(String boardName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BoardListScreen(boardName: boardName, repository: _boardRepo),
      ),
    );
  }

  void _openGallery(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GalleryScreen(title: title, repository: _boardRepo)),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(subtitle, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E1),
      appBar: AppBar(
        title: const Text('마이스터고 무드보드'),
        backgroundColor: const Color(0xFFFBBF24),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  _buildSectionTitle('오늘의 무드보드', '감정 투표와 익명 메시지를 통해 분위기를 확인해보세요.'),
                  const SizedBox(height: 16),
                  StatusBar(totalVotes: _moodRepo.totalVotes, topEmoji: _moodRepo.topEmoji),
                  const SizedBox(height: 16),
                  EmojiVote(
                    selectedEmoji: _selectedEmoji,
                    onVote: _onVote,
                    onSendMessage: _onSendMessage,
                  ),
                  const SizedBox(height: 16),
                  LiveBoard(
                    votes: _moodRepo.getVotes(),
                    messages: _moodRepo.getMessages().map((m) => m.text).toList(),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('반별 게시판', '1-1부터 3-4까지, 그리고 개념글까지 분류되어 있습니다.'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _boardRepo.allBoards.map((boardName) {
                      return GestureDetector(
                        onTap: () => _openBoard(boardName),
                        child: Container(
                          width: 140,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              const BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.05),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(boardName == 'Concept' ? Icons.lightbulb : Icons.school, color: const Color(0xFFFBBF24), size: 28),
                              const SizedBox(height: 12),
                              Text(boardName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text(boardName == 'Concept' ? '개념 정리' : '클래스 게시판', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('갤러리', '프론트엔드, 백엔드, 모바일, 디자인까지 다양한 영감을 모았습니다.'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: const [
                      {'title': '프론트엔드 갤러리', 'icon': Icons.web},
                      {'title': '백엔드 갤러리', 'icon': Icons.storage},
                      {'title': '안드로이드 갤러리', 'icon': Icons.android},
                      {'title': 'Flutter 갤러리', 'icon': Icons.flutter_dash},
                      {'title': 'iOS 갤러리', 'icon': Icons.phone_iphone},
                      {'title': '정보보안 갤러리', 'icon': Icons.security},
                      {'title': '디자인 갤러리', 'icon': Icons.palette},
                    ].map((item) {
                      return GestureDetector(
                        onTap: () => _openGallery(item['title'] as String),
                        child: Container(
                          width: 180,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFFFEF3C7), Color(0xFFFFFFFF)]),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFF9E3A9)),
                          ),
                          child: Column(
                            children: [
                              Icon(item['icon'] as IconData, color: const Color(0xFFB45309), size: 30),
                              const SizedBox(height: 12),
                              Text(item['title'] as String, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('인기 개념글', '좋아요와 댓글이 많은 글을 먼저 확인해보세요.'),
                  const SizedBox(height: 12),
                  ..._boardRepo.trendingPosts.map((post) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => _openBoard(post.boardName),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              const BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.04), blurRadius: 10, offset: Offset(0, 4)),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(post.content, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[800])),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${post.likes} 좋아요', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                    Text('${post.comments.length} 댓글', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
