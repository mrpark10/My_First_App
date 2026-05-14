// 메인 화면 한 페이지.
// StatusBar / EmojiVote / LiveBoard 세 위젯을 위에서 아래로 쌓습니다.
// 데이터는 MoodRepository 한 곳에서 관리하고, 버튼이 눌리면 setState 로 갱신.

import 'package:flutter/material.dart';
import '../data/mood_repository.dart';
import '../widgets/status_bar.dart';
import '../widgets/emoji_vote.dart';
import '../widgets/live_board.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MoodRepository _repo = MoodRepository();

  void _onVote(String emoji) {
    setState(() => _repo.addVote(emoji));
  }

  void _onSendMessage(String text) {
    setState(() => _repo.addMessage(text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E1),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  StatusBar(
                    totalVotes: _repo.totalVotes,
                    topEmoji: _repo.topEmoji,
                  ),
                  const SizedBox(height: 16),
                  EmojiVote(onVote: _onVote, onSendMessage: _onSendMessage),
                  const SizedBox(height: 16),
                  Expanded(
                    child: LiveBoard(
                      votes: _repo.getVotes(),
                      messages: _repo.getMessages().map((m) => m.text).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
