// 화면 하단 위젯.
// 위쪽: 이모지별 가로 바 차트.
// 아래쪽: 익명 메시지 리스트 (최신 메시지가 위로 오게).

import 'package:flutter/material.dart';

class LiveBoard extends StatelessWidget {
  final Map<String, int> votes;
  final List<String> messages;

  const LiveBoard({super.key, required this.votes, required this.messages});

  @override
  Widget build(BuildContext context) {
    final maxVote = votes.values.fold<int>(1, (a, b) => a > b ? a : b);
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '실시간 마음 전광판',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...votes.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(e.key, style: const TextStyle(fontSize: 24)),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: maxVote == 0 ? 0 : e.value / maxVote,
                          backgroundColor: const Color(0xFFF3E8D0),
                          valueColor:
                              const AlwaysStoppedAnimation(Color(0xFFFBBF24)),
                          minHeight: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 36,
                      child: Text(
                        '${e.value}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '익명 메시지',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 220,
              child: messages.isEmpty
                  ? const Center(
                      child: Text(
                        '아직 메시지가 없어요',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      reverse: true,
                      itemCount: messages.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 4),
                      itemBuilder: (_, i) {
                        final msg = messages[messages.length - 1 - i];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF5E1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                            border: Border(
                              left: BorderSide(
                                  color: Color(0xFFFBBF24), width: 3),
                            ),
                          ),
                          child: Text(msg),
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
