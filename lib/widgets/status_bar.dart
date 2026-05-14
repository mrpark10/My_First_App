// 화면 상단 위젯.
// 메인 문구 + 참여 인원수 + 가장 많이 선택된 이모지(👑) 를 보여줍니다.

import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  final int totalVotes;
  final String topEmoji;

  const StatusBar({super.key, required this.totalVotes, required this.topEmoji});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '지금 우리 반은 어떤 기분일까?',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '총 $totalVotes명 참여',
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
            if (topEmoji.isNotEmpty)
              Row(
                children: [
                  const Text('👑 ', style: TextStyle(fontSize: 18)),
                  Text(topEmoji, style: const TextStyle(fontSize: 26)),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
