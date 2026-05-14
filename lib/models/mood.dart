// 감정(이모지) 한 종류를 표현하는 데이터 모델.

class Mood {
  final String key;
  final String emoji;
  final String label;

  const Mood({required this.key, required this.emoji, required this.label});
}

const kDefaultMoods = <Mood>[
  Mood(key: 'happy',   emoji: '😊', label: '행복'),
  Mood(key: 'neutral', emoji: '😐', label: '그저 그럼'),
  Mood(key: 'sleepy',  emoji: '😴', label: '졸림'),
  Mood(key: 'sad',     emoji: '😢', label: '슬픔'),
  Mood(key: 'angry',   emoji: '😡', label: '화남'),
];
