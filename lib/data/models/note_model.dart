import 'package:json_annotation/json_annotation.dart';
import 'package:notes_sqlite/domain/entities/note_entity.dart';

part 'note_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NoteModel extends NoteEntity {
  const NoteModel({
    super.id,
    required super.title,
    required super.content,
    required super.color,
    super.startTime,
    super.endTime,
    super.createdAt,
    super.updatedAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);

  Map<String, dynamic> toJson() => _$NoteModelToJson(this);

  NoteEntity toEntity() {
    return NoteEntity(
      title: title,
      content: content,
      color: color,
      createdAt: createdAt,
      endTime: endTime,
      id: id,
      startTime: startTime,
      updatedAt: updatedAt,
    );
  }

  factory NoteModel.fromEntity(NoteEntity entity) {
    return NoteModel(
      title: entity.title,
      content: entity.content,
      color: entity.color,
      createdAt: entity.createdAt,
      endTime: entity.endTime,
      id: entity.id,
      startTime: entity.startTime,
      updatedAt: entity.updatedAt,
    );
  }
}
