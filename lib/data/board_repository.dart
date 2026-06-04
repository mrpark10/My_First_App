import '../models/board_comment.dart';
import '../models/board_post.dart';

class BoardRepository {
  final List<String> classBoards = const [
    '1-1', '1-2', '1-3', '1-4',
    '2-1', '2-2', '2-3', '2-4',
    '3-1', '3-2', '3-3', '3-4',
  ];

  final List<String> galleryBoards = const [
    '프론트엔드 갤러리',
    '백엔드 갤러리',
    '안드로이드 갤러리',
    'Flutter 갤러리',
    'iOS 갤러리',
    '정보보안 갤러리',
    '디자인 갤러리',
  ];

  final Map<String, List<BoardPost>> _posts = {};

  BoardRepository() {
    for (final board in classBoards) {
      _posts[board] = _createSamplePosts(board);
    }
    _posts['Concept'] = _createConceptPosts();
    for (final gallery in galleryBoards) {
      _posts[gallery] = _createGalleryPosts(gallery);
    }
  }

  List<BoardPost> _createSamplePosts(String boardName) {
    return [
      BoardPost(
        id: '$boardName-1',
        boardName: boardName,
        title: '친구와 함께한 오늘의 프로젝트',
        content: '오늘은 새로운 앱 UI를 설계했어요. 팀원들과 아이디어를 많이 나눴습니다.',
        author: '익명',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        likes: 5,
        comments: [
          BoardComment(
            id: '$boardName-1-c1',
            author: '익명',
            message: '정말 멋진 아이디어네요!',
            createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 20)),
          ),
        ],
      ),
      BoardPost(
        id: '$boardName-2',
        boardName: boardName,
        title: '이번 주 스터디 추천',
        content: '프론트엔드와 백엔드 관련 도서를 서로 추천해보아요.',
        author: '익명',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
        likes: 3,
      ),
    ];
  }

  List<BoardPost> _createConceptPosts() {
    return [
      BoardPost(
        id: 'concept-1',
        boardName: 'Concept',
        title: '좋은 UX가 필요한 이유',
        content:
            '사용자는 복잡한 인터페이스에서 쉽게 이탈합니다. 단순한 흐름과 명확한 피드백을 설계하는 것이 중요합니다.',
        author: '강사',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        concept: true,
        likes: 12,
        comments: [
          BoardComment(
            id: 'concept-1-c1',
            author: '익명',
            message: '이 부분을 이번 프로젝트에 꼭 반영해야겠어요.',
            createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
          ),
        ],
      ),
      BoardPost(
        id: 'concept-2',
        boardName: 'Concept',
        title: '클린 코드와 협업',
        content:
            '코드의 가독성은 팀 생산성을 높이는 핵심 요소입니다. 작은 규칙을 지켜도 큰 차이가 납니다.',
        author: '강사',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        concept: true,
        likes: 9,
      ),
    ];
  }
  List<BoardPost> _createGalleryPosts(String galleryName) {
    final shortName = galleryName.replaceAll(' 갤러리', '');
    return [
      BoardPost(
        id: '${galleryName.replaceAll(' ', '_')}-1',
        boardName: galleryName,
        title: '좋은 $shortName 구성 요소',
        content: '이 $galleryName를 활용하는 방법과 핵심 포인트를 정리해보았습니다.',
        author: '익명',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        likes: 0,
        comments: [
          BoardComment(
            id: '${galleryName.replaceAll(' ', '_')}-1-c1',
            author: '익명',
            message: '이 내용이 정말 도움이 됩니다!',
            createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          ),
        ],
      ),
      BoardPost(
        id: '${galleryName.replaceAll(' ', '_')}-2',
        boardName: galleryName,
        title: '실무에서 자주 쓰는 $shortName 팁',
        content: '현업에서 자주 활용되는 패턴과 경험을 나눕니다.',
        author: '강사',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        concept: true,
        likes: 0,
      ),
    ];
  }
  List<String> get allBoards => [...classBoards, 'Concept'];
  List<String> get allGalleryBoards => [...galleryBoards];

  List<BoardPost> getPosts(String boardName) => List.unmodifiable(_posts[boardName] ?? []);

  BoardPost? getPostById(String boardName, String postId) {
    final posts = _posts[boardName];
    if (posts == null) return null;

    for (final post in posts) {
      if (post.id == postId) {
        return post;
      }
    }
    return null;
  }

  BoardComment? _findComment(List<BoardComment> comments, String commentId) {
    for (final comment in comments) {
      if (comment.id == commentId) return comment;
      final reply = _findComment(comment.replies, commentId);
      if (reply != null) return reply;
    }
    return null;
  }

  void addComment(String boardName, String postId, String message, {String? parentCommentId}) {
    final post = getPostById(boardName, postId);
    if (post == null || message.trim().isEmpty) return;

    if (parentCommentId == null) {
      post.comments.add(
        BoardComment(
          id: '${post.id}-c${post.comments.length + 1}',
          author: '익명',
          message: message.trim(),
          createdAt: DateTime.now(),
        ),
      );
      return;
    }

    final parentComment = _findComment(post.comments, parentCommentId);
    if (parentComment == null) return;

    parentComment.replies.add(
      BoardComment(
        id: '${parentComment.id}-r${parentComment.replies.length + 1}',
        author: '익명',
        message: message.trim(),
        createdAt: DateTime.now(),
      ),
    );
  }

  void addPost(String boardName, String title, String content, {bool concept = false, String author = '익명'}) {
    final posts = _posts[boardName];
    if (posts == null || title.trim().isEmpty || content.trim().isEmpty) return;

    final nextId = '${boardName.replaceAll(' ', '_')}-${posts.length + 1}';
    posts.insert(
      0,
      BoardPost(
        id: nextId,
        boardName: boardName,
        title: title.trim(),
        content: content.trim(),
        author: author,
        createdAt: DateTime.now(),
        concept: concept,
        likes: 0,
      ),
    );
  }

  void toggleLike(String boardName, String postId, bool isLiked) {
    final post = getPostById(boardName, postId);
    if (post == null) return;

    if (isLiked) {
      post.likes += 1;
    } else if (post.likes > 0) {
      post.likes -= 1;
    }
  }

  List<BoardPost> get trendingPosts {
    final posts = _posts.values.expand((list) => list).toList();
    posts.sort((a, b) {
      final scoreA = a.likes + a.comments.length * 2 + (a.concept ? 5 : 0);
      final scoreB = b.likes + b.comments.length * 2 + (b.concept ? 5 : 0);
      return scoreB.compareTo(scoreA);
    });
    return posts.take(5).toList();
  }
}
