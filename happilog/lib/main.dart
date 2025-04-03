import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'HappiLog',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CalendarScreen(),
    ),
    GoRoute(
      path: '/record',
      builder: (context, state) => const RecordScreen(),
    ),
    GoRoute(
      path: '/avatar',
      builder: (context, state) => const AvatarScreen(),
    ),
    GoRoute(
      path: '/rankings',
      builder: (context, state) => const RankingsScreen(),
    ),
  ],
);

// 임시 화면들
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HappiLog', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade800,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 오늘의 행복 카드
                  _buildTodayCard(context),
                  
                  const SizedBox(height: 24),
                  
                  // 최근 행복 기록
                  const Text(
                    '최근 행복 기록',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRecentRecordsList(),
                  
                  const SizedBox(height: 24),
                  
                  // 행복 통계
                  const Text(
                    '나의 행복 통계',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildHappinessStats(),
                ],
              ),
            ),
          ),
          _buildNavigationBar(context),
        ],
      ),
    );
  }
  
  Widget _buildTodayCard(BuildContext context) {
    return Card(
      color: Colors.green.shade700,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.green.shade200, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '오늘의 행복',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _getFormattedDate(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green.shade100,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.white30),
            const SizedBox(height: 12),
            const Text(
              '아직 오늘의 행복을 기록하지 않았어요!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/record'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '지금 기록하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRecentRecordsList() {
    // 임시 데이터
    final recentRecords = [
      {'date': '2023-10-24', 'happiness': 4, 'content': '친구와 맛있는 저녁을 먹었다'},
      {'date': '2023-10-23', 'happiness': 5, 'content': '오랜만에 영화를 봤다'},
      {'date': '2023-10-22', 'happiness': 3, 'content': '좋은 책을 읽었다'},
    ];
    
    return Card(
      color: Colors.grey.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recentRecords.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.grey),
        itemBuilder: (context, index) {
          final record = recentRecords[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text(
                record['happiness'].toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              record['content'] as String,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(record['date'] as String),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          );
        },
      ),
    );
  }
  
  Widget _buildHappinessStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('평균 행복도', '4.2', Icons.sentiment_satisfied_alt),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('기록 일수', '23일', Icons.calendar_today),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('연속 기록', '7일', Icons.local_fire_department),
        ),
      ],
    );
  }
  
  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      color: Colors.grey.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: Colors.green, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getFormattedDate() {
    final now = DateTime.now();
    return '${now.year}년 ${now.month}월 ${now.day}일';
  }
}

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('행복 캘린더'),
        backgroundColor: Colors.green.shade800,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMonthSelector(),
                  const SizedBox(height: 16),
                  _buildCalendarGrid(),
                  const SizedBox(height: 24),
                  const Text(
                    '이번 달 행복 통계',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMonthlyStats(),
                ],
              ),
            ),
          ),
          _buildNavigationBar(context),
        ],
      ),
    );
  }
  
  Widget _buildMonthSelector() {
    final now = DateTime.now();
    final monthText = '${now.year}년 ${now.month}월';
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {},
        ),
        Text(
          monthText,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {},
        ),
      ],
    );
  }
  
  Widget _buildCalendarGrid() {
    // 요일 헤더
    final dayLabels = ['일', '월', '화', '수', '목', '금', '토'];
    
    return Card(
      color: Colors.grey.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 요일 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: dayLabels.map((day) => 
                Text(
                  day, 
                  style: TextStyle(
                    color: day == '일' ? Colors.red : day == '토' ? Colors.blue : Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ).toList(),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 12),
            
            // 달력 그리드 (예시로 5주 표시)
            ...List.generate(5, (weekIndex) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (dayIndex) {
                    final day = weekIndex * 7 + dayIndex - 4; // 임의의 시작일 설정
                    final isCurrentMonth = day > 0 && day <= 31;
                    
                    // 임의의 행복도 데이터 (1~5)
                    final hasRecord = isCurrentMonth && day % 3 != 0;
                    final happinessLevel = hasRecord ? (day % 5) + 1 : 0;
                    
                    return _buildDayCell(day, isCurrentMonth, happinessLevel);
                  }),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDayCell(int day, bool isCurrentMonth, int happinessLevel) {
    // 날짜가 현재 달에 속하지 않으면 빈 셀 표시
    if (!isCurrentMonth) {
      return const SizedBox(
        width: 40,
        height: 40,
      );
    }
    
    // 행복도에 따른 색상 설정
    Color cellColor = Colors.transparent;
    if (happinessLevel > 0) {
      // 행복도에 따라 색상 강도 조절
      final colorIntensity = 0.5 + (happinessLevel * 0.1);
      cellColor = Colors.green.withOpacity(colorIntensity);
    }
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: cellColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: happinessLevel > 0 ? Colors.green.shade200 : Colors.grey.shade700,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          day.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: happinessLevel > 0 ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
  
  Widget _buildMonthlyStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('이번 달 기록', '18일', Icons.event_note),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('평균 행복도', '4.1', Icons.sentiment_satisfied_alt),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('최장 연속', '5일', Icons.trending_up),
        ),
      ],
    );
  }
  
  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      color: Colors.grey.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: Colors.green, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  int _selectedHappiness = 3;
  final TextEditingController _contentController = TextEditingController();
  
  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('행복 기록하기'),
        backgroundColor: Colors.green.shade800,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '오늘의 날짜: ${_getFormattedDate()}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  const Text(
                    '오늘의 행복도는 어느 정도인가요?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildHappinessSelector(),
                  const SizedBox(height: 24),
                  
                  const Text(
                    '어떤 일이 있었나요?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _contentController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: '오늘 있었던 행복한 일을 기록해보세요...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveRecord,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '저장하기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildNavigationBar(context),
        ],
      ),
    );
  }
  
  Widget _buildHappinessSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        final level = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedHappiness = level;
            });
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _selectedHappiness == level ? Colors.green : Colors.grey.shade800,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedHappiness == level ? Colors.green.shade200 : Colors.grey.shade600,
                    width: 2,
                  ),
                ),
                child: Icon(
                  _getEmotionIcon(level),
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getEmotionText(level),
                style: TextStyle(
                  color: _selectedHappiness == level ? Colors.green : Colors.grey,
                  fontWeight: _selectedHappiness == level ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
  
  IconData _getEmotionIcon(int level) {
    switch (level) {
      case 1: return Icons.sentiment_very_dissatisfied;
      case 2: return Icons.sentiment_dissatisfied;
      case 3: return Icons.sentiment_neutral;
      case 4: return Icons.sentiment_satisfied;
      case 5: return Icons.sentiment_very_satisfied;
      default: return Icons.sentiment_neutral;
    }
  }
  
  String _getEmotionText(int level) {
    switch (level) {
      case 1: return '매우 나쁨';
      case 2: return '나쁨';
      case 3: return '보통';
      case 4: return '좋음';
      case 5: return '매우 좋음';
      default: return '보통';
    }
  }
  
  void _saveRecord() {
    if (_contentController.text.isEmpty) {
      // 에러 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('내용을 입력해주세요')),
      );
      return;
    }
    
    // 데이터 저장 로직 (Firebase 없이 임시 로직)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('오늘의 행복이 저장되었습니다!')),
    );
    
    // 홈 화면으로 이동
    context.go('/');
  }
  
  String _getFormattedDate() {
    final now = DateTime.now();
    return '${now.year}년 ${now.month}월 ${now.day}일';
  }
}

class AvatarScreen extends StatelessWidget {
  const AvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 아바타'),
        backgroundColor: Colors.green.shade800,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAvatarSection(),
                  const SizedBox(height: 24),
                  
                  // 아바타 아이템 목록
                  const Text(
                    '아바타 아이템',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildAvatarItems(),
                  
                  const SizedBox(height: 24),
                  
                  // 업적 목록
                  const Text(
                    '나의 업적',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildAchievements(),
                ],
              ),
            ),
          ),
          _buildNavigationBar(context),
        ],
      ),
    );
  }
  
  Widget _buildAvatarSection() {
    return Card(
      color: Colors.grey.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            
            // 아바타 이미지
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                border: Border.all(color: Colors.green.shade200, width: 3),
                borderRadius: BorderRadius.circular(90),
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  size: 120,
                  color: Colors.green.shade200,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            const Text(
              '행복왕',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '행복 포인트: 1,250점',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green.shade200,
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _AvatarStat(label: '기록 횟수', value: '85'),
                SizedBox(width: 24),
                _AvatarStat(label: '평균 행복도', value: '4.2'),
                SizedBox(width: 24),
                _AvatarStat(label: '아이템 수', value: '12'),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAvatarItems() {
    final avatarItems = [
      {'name': '모자', 'isOwned': true},
      {'name': '안경', 'isOwned': true},
      {'name': '망토', 'isOwned': true},
      {'name': '배경', 'isOwned': false},
      {'name': '펫', 'isOwned': false},
      {'name': '무기', 'isOwned': false},
    ];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: avatarItems.length,
      itemBuilder: (context, index) {
        final item = avatarItems[index];
        final isOwned = item['isOwned'] as bool;
        
        return Card(
          color: isOwned ? Colors.green.shade700 : Colors.grey.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isOwned ? Colors.green.shade200 : Colors.grey.shade600,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getItemIcon(item['name'] as String),
                size: 40,
                color: isOwned ? Colors.white : Colors.grey.shade400,
              ),
              const SizedBox(height: 8),
              Text(
                item['name'] as String,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isOwned ? Colors.white : Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isOwned ? '장착 중' : '잠김',
                style: TextStyle(
                  fontSize: 12,
                  color: isOwned ? Colors.green.shade100 : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  IconData _getItemIcon(String itemName) {
    switch (itemName) {
      case '모자': return Icons.face;
      case '안경': return Icons.visibility;
      case '망토': return Icons.style;
      case '배경': return Icons.image;
      case '펫': return Icons.pets;
      case '무기': return Icons.bolt;
      default: return Icons.help;
    }
  }
  
  Widget _buildAchievements() {
    final achievements = [
      {'name': '첫 기록', 'desc': '첫 번째 행복을 기록하세요', 'isCompleted': true},
      {'name': '일주일 연속', 'desc': '7일 연속으로 행복을 기록하세요', 'isCompleted': true},
      {'name': '한 달 기록', 'desc': '한 달 동안 20일 이상 기록하세요', 'isCompleted': false},
      {'name': '행복 대장', 'desc': '행복도 5점을 10회 이상 기록하세요', 'isCompleted': false},
    ];
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        final isCompleted = achievement['isCompleted'] as bool;
        
        return Card(
          color: Colors.grey.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.grey.shade600,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.lock,
                color: Colors.white,
              ),
            ),
            title: Text(
              achievement['name'] as String,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isCompleted ? Colors.white : Colors.grey.shade400,
              ),
            ),
            subtitle: Text(
              achievement['desc'] as String,
              style: TextStyle(
                color: isCompleted ? Colors.grey.shade300 : Colors.grey.shade500,
              ),
            ),
            trailing: isCompleted 
              ? const Icon(Icons.emoji_events, color: Colors.amber)
              : null,
          ),
        );
      },
    );
  }
}

class _AvatarStat extends StatelessWidget {
  final String label;
  final String value;
  
  const _AvatarStat({
    required this.label,
    required this.value,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}

class RankingsScreen extends StatelessWidget {
  const RankingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('행복 랭킹'),
        backgroundColor: Colors.green.shade800,
      ),
      body: Column(
        children: [
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    tabs: const [
                      Tab(text: '주간 랭킹'),
                      Tab(text: '월간 랭킹'),
                      Tab(text: '친구 랭킹'),
                    ],
                    indicatorColor: Colors.green,
                    labelColor: Colors.green,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildRankingTab('weekly'),
                        _buildRankingTab('monthly'),
                        _buildRankingTab('friends'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildNavigationBar(context),
        ],
      ),
    );
  }
  
  Widget _buildRankingTab(String type) {
    // 임시 데이터 생성
    final List<Map<String, dynamic>> rankings = [];
    final int itemCount = type == 'friends' ? 5 : 10;
    
    for (int i = 0; i < itemCount; i++) {
      rankings.add({
        'rank': i + 1,
        'name': '사용자${i + 1}',
        'points': 1000 - (i * 50) + (i % 3 * 12),
        'isMe': i == 3,
      });
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 내 등수 표시 카드
          _buildMyRankingCard(rankings.firstWhere((r) => r['isMe'] == true)),
          
          const SizedBox(height: 20),
          
          // 랭킹 리스트
          ...rankings.map((ranking) => _buildRankingItem(ranking)),
        ],
      ),
    );
  }
  
  Widget _buildMyRankingCard(Map<String, dynamic> myRanking) {
    return Card(
      color: Colors.green.shade700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.green.shade200, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  myRanking['rank'].toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '나의 랭킹',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${myRanking['points']} 포인트',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.trending_up, color: Colors.white),
                const SizedBox(height: 4),
                Text(
                  '상위 ${(myRanking['rank'] / 10 * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRankingItem(Map<String, dynamic> ranking) {
    final bool isMe = ranking['isMe'] == true;
    final Color cardColor = isMe ? Colors.green.withOpacity(0.2) : Colors.transparent;
    final Color borderColor = isMe ? Colors.green.shade300 : Colors.transparent;
    
    // 랭킹별 메달 색상
    Color medalColor;
    switch (ranking['rank']) {
      case 1: medalColor = Colors.amber; // 금
      case 2: medalColor = Colors.grey.shade300; // 은
      case 3: medalColor = Colors.brown.shade300; // 동
      default: medalColor = Colors.transparent;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ranking['rank'] <= 3 ? medalColor : Colors.grey.shade800,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              ranking['rank'].toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ranking['rank'] <= 3 ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
        title: Text(
          ranking['name'],
          style: TextStyle(
            fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Text(
          '${ranking['points']} 포인트',
          style: TextStyle(
            color: isMe ? Colors.green : Colors.grey.shade400,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

Widget _buildNavigationBar(BuildContext context) {
  return Container(
    color: Colors.grey.shade900,
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNavButton(context, Icons.home, '/', '홈'),
        _buildNavButton(context, Icons.calendar_month, '/calendar', '캘린더'),
        _buildNavButton(context, Icons.add_circle, '/record', '기록'),
        _buildNavButton(context, Icons.person, '/avatar', '아바타'),
        _buildNavButton(context, Icons.leaderboard, '/rankings', '랭킹'),
      ],
    ),
  );
}

Widget _buildNavButton(BuildContext context, IconData icon, String route, String label) {
  final bool isSelected = GoRouterState.of(context).matchedLocation == route;
  
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        onPressed: () => context.go(route),
        icon: Icon(
          icon,
          color: isSelected ? Colors.green : Colors.grey,
          size: 28,
        ),
      ),
      Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.green : Colors.grey,
          fontSize: 12,
        ),
      ),
    ],
  );
}
