// 익명 메시지 한 개를 표현하는 데이터 모델.

class Message {
  final String text;
  final DateTime createdAt;

  Message({required this.text, required this.createdAt});

  Map<String, dynamic> toJson() => {
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        text: json['text'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
