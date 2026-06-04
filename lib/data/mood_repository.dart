// 메모리에만 저장하는 간단한 저장소.
// 다음 스텝에서 shared_preferences (로컬 영구 저장) 또는
// Firestore (실시간 다중 사용자 공유) 로 교체할 수 있습니다.

import '../models/message.dart';
import '../models/mood.dart';

class MoodRepository {
  final Map<String, int> _votes = {
    for (final m in kDefaultMoods) m.emoji: 0,
  };
  final List<Message> _messages = [];

  Map<String, int> getVotes() => Map.unmodifiable(_votes);

  void addVote(String emoji) {
    if (_votes.containsKey(emoji)) {
      _votes[emoji] = _votes[emoji]! + 1;
    }
  }

  void removeVote(String emoji) {
    if (_votes.containsKey(emoji) && _votes[emoji]! > 0) {
      _votes[emoji] = _votes[emoji]! - 1;
    }
  }

  List<Message> getMessages() => List.unmodifiable(_messages);

  void addMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _messages.add(Message(text: trimmed, createdAt: DateTime.now()));
  }

  int get totalVotes => _votes.values.fold(0, (a, b) => a + b);

  String get topEmoji {
    String top = '';
    int max = 0;
    _votes.forEach((emoji, count) {
      if (count > max) {
        max = count;
        top = emoji;
      }
    });
    return top;
  }
}
