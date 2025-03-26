import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

enum Emotion {
  happy,
  sad,
  neutral,
}

class DailyRecord {
  final String id;
  final String text;
  final String? imageUrl;
  final Emotion emotion;
  final DateTime date;

  DailyRecord({
    String? id,
    required this.text,
    this.imageUrl,
    required this.emotion,
    required this.date,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
      'emotion': emotion.name,
      'date': Timestamp.fromDate(date),
    };
  }

  factory DailyRecord.fromMap(Map<String, dynamic> map) {
    return DailyRecord(
      id: map['id'],
      text: map['text'],
      imageUrl: map['imageUrl'],
      emotion: Emotion.values.firstWhere(
        (e) => e.name == map['emotion'],
        orElse: () => Emotion.neutral,
      ),
      date: (map['date'] as Timestamp).toDate(),
    );
  }

  DailyRecord copyWith({
    String? id,
    String? text,
    String? imageUrl,
    Emotion? emotion,
    DateTime? date,
  }) {
    return DailyRecord(
      id: id ?? this.id,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      emotion: emotion ?? this.emotion,
      date: date ?? this.date,
    );
  }
} 