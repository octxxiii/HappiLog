import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String id;
  final String title;
  final String description;
  final String creatorId;
  final List<String> participants;
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, int> participantScores;
  final bool isActive;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.creatorId,
    required this.participants,
    required this.startDate,
    required this.endDate,
    required this.participantScores,
    required this.isActive,
  });

  factory Challenge.fromMap(Map<String, dynamic> map, String id) {
    return Challenge(
      id: id,
      title: map['title'] as String,
      description: map['description'] as String,
      creatorId: map['creatorId'] as String,
      participants: List<String>.from(map['participants'] as List),
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      participantScores: Map<String, int>.from(map['participantScores'] as Map),
      isActive: map['isActive'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'creatorId': creatorId,
      'participants': participants,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'participantScores': participantScores,
      'isActive': isActive,
    };
  }

  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    String? creatorId,
    List<String>? participants,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, int>? participantScores,
    bool? isActive,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      participants: participants ?? this.participants,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      participantScores: participantScores ?? this.participantScores,
      isActive: isActive ?? this.isActive,
    );
  }
} 