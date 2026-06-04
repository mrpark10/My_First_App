// 화면 중앙 위젯.
// 큼직한 이모지 버튼 5개 + "기분을 한 줄로" 입력창.
// 버튼/엔터 시 부모 콜백(onVote / onSendMessage) 으로 알립니다.

import 'package:flutter/material.dart';
import '../models/mood.dart';

class EmojiVote extends StatefulWidget {
  final void Function(String emoji) onVote;
  final void Function(String message) onSendMessage;
  final String selectedEmoji;

  const EmojiVote({
    super.key,
    required this.onVote,
    required this.onSendMessage,
    required this.selectedEmoji,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 10,
              children: kDefaultMoods.map((mood) {
                final selected = mood.emoji == widget.selectedEmoji;
                return InkWell(
                  onTap: () => widget.onVote(mood.emoji),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFFFFE7A5) : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected ? const Color(0xFFF59E0B) : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      mood.emoji,
                      style: TextStyle(fontSize: 42, shadows: selected ? [const Shadow(color: Colors.black26, blurRadius: 8)] : null),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '기분을 한 줄로 표현해보세요 (선택)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      filled: true,
                      fillColor: const Color(0xFFF7F4EA),
                      isDense: true,
                      counterText: '',
                    ),
                    maxLength: 40,
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _send,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBBF24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  ),
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
