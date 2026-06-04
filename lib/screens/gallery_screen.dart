import 'package:flutter/material.dart';
import '../data/board_repository.dart';
import 'board_list_screen.dart';

class GalleryScreen extends StatelessWidget {
  final String title;
  final BoardRepository repository;

  const GalleryScreen({super.key, required this.title, required this.repository});

  static const galleryItems = [
    {'title': '프론트엔드 갤러리', 'subtitle': '웹 UI/UX와 화면 구성 아이디어', 'icon': Icons.web},
    {'title': '백엔드 갤러리', 'subtitle': '서버, API, DB 설계 노하우', 'icon': Icons.storage},
    {'title': '안드로이드 갤러리', 'subtitle': '앱 개발과 네이티브 경험', 'icon': Icons.android},
    {'title': 'Flutter 갤러리', 'subtitle': '크로스 플랫폼 화면 구성', 'icon': Icons.flutter_dash},
    {'title': 'iOS 갤러리', 'subtitle': '모바일 디자인과 인터랙션', 'icon': Icons.phone_iphone},
    {'title': '정보보안 갤러리', 'subtitle': '보안, 해킹 방지, 암호화', 'icon': Icons.security},
    {'title': '디자인 갤러리', 'subtitle': '브랜딩과 UI 디자인 참고', 'icon': Icons.palette},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFFBBF24),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: galleryItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 4.5,
          ),
          itemBuilder: (context, index) {
            final item = galleryItems[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BoardListScreen(
                        boardName: item['title'] as String,
                        repository: repository,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: const Color(0xFFFFF3D4),
                        child: Icon(item['icon'] as IconData, color: const Color(0xFFFBBF24), size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(item['subtitle'] as String, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
