// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:happilog/models/daily_record.dart';

void main() {
  test('기본 단위 테스트', () {
    expect(1 + 1, equals(2));
    expect(true, isTrue);
    expect('Happilog', contains('log'));
  });
  
  group('DailyRecord 모델 테스트', () {
    test('생성자와 getter 테스트', () {
      final now = DateTime.now();
      final record = DailyRecord(
        id: 'test-id',
        text: '행복한 하루',
        emotion: Emotion.happy,
        date: now,
      );
      
      expect(record.id, equals('test-id'));
      expect(record.text, equals('행복한 하루'));
      expect(record.emotion, equals(Emotion.happy));
      expect(record.date, equals(now));
      expect(record.imageUrl, isNull);
    });
    
    test('toMap 메서드 테스트', () {
      final now = DateTime.now();
      final record = DailyRecord(
        id: 'test-id',
        text: '행복한 하루',
        emotion: Emotion.happy,
        date: now,
        imageUrl: 'http://example.com/image.jpg',
      );
      
      final map = record.toMap();
      
      expect(map['id'], equals('test-id'));
      expect(map['text'], equals('행복한 하루'));
      expect(map['emotion'], equals('happy'));
      expect(map['imageUrl'], equals('http://example.com/image.jpg'));
      expect(map['date'], isA<Timestamp>());
    });
    
    test('fromMap 메서드 테스트', () {
      final now = DateTime.now();
      final timestamp = Timestamp.fromDate(now);
      
      final map = {
        'id': 'test-id',
        'text': '행복한 하루',
        'emotion': 'happy',
        'date': timestamp,
        'imageUrl': 'http://example.com/image.jpg',
      };
      
      final record = DailyRecord.fromMap(map);
      
      expect(record.id, equals('test-id'));
      expect(record.text, equals('행복한 하루'));
      expect(record.emotion, equals(Emotion.happy));
      expect(record.date.year, equals(now.year));
      expect(record.date.month, equals(now.month));
      expect(record.date.day, equals(now.day));
      expect(record.imageUrl, equals('http://example.com/image.jpg'));
    });
    
    test('copyWith 메서드 테스트', () {
      final record = DailyRecord(
        id: 'test-id',
        text: '행복한 하루',
        emotion: Emotion.happy,
        date: DateTime.now(),
      );
      
      final updatedRecord = record.copyWith(
        text: '매우 행복한 하루',
        emotion: Emotion.neutral,
      );
      
      expect(updatedRecord.id, equals('test-id')); // 변경되지 않음
      expect(updatedRecord.text, equals('매우 행복한 하루')); // 변경됨
      expect(updatedRecord.emotion, equals(Emotion.neutral)); // 변경됨
      expect(updatedRecord.date, equals(record.date)); // 변경되지 않음
      expect(updatedRecord.imageUrl, isNull); // 변경되지 않음
    });
  });
}
