import 'package:equatable/equatable.dart';

class NoteEntity extends Equatable {
  final int? id;
  final String title;
  final String content;
  final String color;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NoteEntity({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    this.startTime,
    this.endTime,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    color,
    startTime,
    endTime,
    createdAt,
    updatedAt,
  ];
}
