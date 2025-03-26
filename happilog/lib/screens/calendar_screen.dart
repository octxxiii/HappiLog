import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:happilog/components/pixel_button.dart';
import 'package:happilog/components/pixel_calendar_cell.dart';
import 'package:happilog/models/daily_record.dart';
import 'package:happilog/providers/providers.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _currentMonth;
  
  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }
  
  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month - 1,
        1,
      );
    });
  }
  
  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + 1,
        1,
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final recordsAsyncValue = ref.watch(recordListProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    
    // 현재 월의 시작일
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    // 현재 월의 마지막 일자
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    // 현재 월의 첫째날 요일 (0: 일요일, 1: 월요일, ..., 6: 토요일)
    final firstWeekday = firstDayOfMonth.weekday;
    // 첫째날 전에 표시할 이전 달의 일수
    final daysInPreviousMonth = (firstWeekday == 7) ? 0 : firstWeekday;
    
    // 캘린더에 표시할 날짜 목록
    final calendarDays = <DateTime>[];
    
    // 이전 달 날짜 추가
    final previousMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    final daysInPrevMonth = DateTime(_currentMonth.year, _currentMonth.month, 0).day;
    
    for (int i = daysInPreviousMonth - daysInPreviousMonth + 1; i <= daysInPrevMonth; i++) {
      calendarDays.add(DateTime(previousMonth.year, previousMonth.month, i));
    }
    
    // 현재 달 날짜 추가
    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      calendarDays.add(DateTime(_currentMonth.year, _currentMonth.month, i));
    }
    
    // 다음 달 날짜 추가 (7x5 그리드를 채우기 위해)
    final remainingDays = 35 - calendarDays.length;
    final nextMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    
    for (int i = 1; i <= remainingDays; i++) {
      calendarDays.add(DateTime(nextMonth.year, nextMonth.month, i));
    }
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            
            // 타이틀 및 월 선택
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  DateFormat('yyyy년 MM월').format(_currentMonth),
                  style: const TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 14,
                    color: Colors.amber,
                  ),
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 요일 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _WeekdayLabel('일'),
                _WeekdayLabel('월'),
                _WeekdayLabel('화'),
                _WeekdayLabel('수'),
                _WeekdayLabel('목'),
                _WeekdayLabel('금'),
                _WeekdayLabel('토'),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 캘린더 그리드
            recordsAsyncValue.when(
              data: (records) {
                // 날짜별 기록 여부를 저장하는 맵
                final recordMap = <String, bool>{};
                for (final record in records) {
                  final dateKey = DateFormat('yyyy-MM-dd').format(record.date);
                  recordMap[dateKey] = true;
                }
                
                return Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: calendarDays.length,
                    itemBuilder: (context, index) {
                      final date = calendarDays[index];
                      final dateKey = DateFormat('yyyy-MM-dd').format(date);
                      final hasRecord = recordMap[dateKey] ?? false;
                      final isToday = DateUtils.isSameDay(date, DateTime.now());
                      final isCurrentMonth = date.month == _currentMonth.month;
                      final isSelected = DateUtils.isSameDay(date, selectedDate);
                      
                      return PixelCalendarCell(
                        date: date,
                        isSelected: isSelected,
                        hasRecord: hasRecord,
                        isToday: isToday,
                        isCurrentMonth: isCurrentMonth,
                        onTap: () {
                          ref.read(selectedDateProvider.notifier).state = date;
                          
                          if (hasRecord) {
                            _showDayRecords(records, date);
                          }
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => const Expanded(
                child: Center(child: Text('기록을 불러올 수 없습니다.')),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showDayRecords(List<DailyRecord> allRecords, DateTime date) {
    // 선택한 날짜의 기록만 필터링
    final records = allRecords.where((record) => 
      DateUtils.isSameDay(record.date, date)
    ).toList();
    
    if (records.isEmpty) return;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('yyyy년 MM월 dd일').format(date),
                style: const TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 12,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return GestureDetector(
                      onTap: () {
                        context.go('/entry/${record.id}');
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              color: _getEmotionColor(record.emotion),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                record.text.length > 30 
                                    ? '${record.text.substring(0, 30)}...' 
                                    : record.text,
                                style: const TextStyle(
                                  fontFamily: 'NanumGothicCoding',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              PixelButton(
                text: '닫기',
                onPressed: () => Navigator.of(context).pop(),
                width: 120,
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
  
  Color _getEmotionColor(Emotion emotion) {
    switch (emotion) {
      case Emotion.happy:
        return Colors.amber;
      case Emotion.sad:
        return Colors.blue;
      case Emotion.neutral:
        return Colors.grey;
    }
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String text;
  
  const _WeekdayLabel(this.text);
  
  @override
  Widget build(BuildContext context) {
    final isWeekend = text == '토' || text == '일';
    
    return Container(
      width: 40,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: isWeekend
              ? (text == '일' ? Colors.red.withOpacity(0.7) : Colors.blue.withOpacity(0.7))
              : Colors.white.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'PressStart2P',
          fontSize: 10,
          color: isWeekend
              ? (text == '일' ? Colors.red.shade300 : Colors.blue.shade300)
              : Colors.white,
        ),
      ),
    );
  }
} 