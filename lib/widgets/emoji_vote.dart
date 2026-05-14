// 화면 중앙 위젯.
// 큼직한 이모지 버튼 5개 + "기분을 한 줄로" 입력창.
// 버튼/엔터 시 부모 콜백(onVote / onSendMessage) 으로 알립니다.

import 'package:flutter/material.dart';
import '../models/mood.dart';

class EmojiVote extends StatefulWidget {
  final void Function(String emoji) onVote;
  final void Function(String message) onSendMessage;

  const EmojiVote({
    super.key,
    required this.onVote,
    required this.onSendMessage,
  });

  @override
  State<EmojiVote> createState() => _EmojiVoteState();
}

class _EmojiVoteState extends State<EmojiVote> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSendMessage(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: kDefaultMoods.map((mood) {
                return InkWell(
                  onTap: () => widget.onVote(mood.emoji),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      mood.emoji,
                      style: const TextStyle(fontSize: 44),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '기분을 한 줄로 표현해봐! (선택)',
                      border: OutlineInputBorder(),
                      isDense: true,
                      counterText: '',
                    ),
                    maxLength: 40,
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _send,
                  child: const Text('보내기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
