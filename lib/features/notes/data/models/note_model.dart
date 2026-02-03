final class NoteModel {
  final int? id;
  final String? remoteId;
  final String title;
  final String content;
  final int categoryId;
  final int isPinned;
  final int isSynced;
  final int isDeletedLocally;
  final String createdAt;
  final String updatedAt;

  const NoteModel({
    this.id,
    this.remoteId,
    required this.title,
    required this.content,
    required this.categoryId,
    this.isPinned = 0,
    this.isSynced = 0,
    this.isDeletedLocally = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  NoteModel copyWith({
    int? categoryId,
    String? updatedAt,
    int? isPinned,
  }) {
    return NoteModel(
      id: id,
      remoteId: remoteId,
      title: title,
      content: content,
      categoryId: categoryId ?? this.categoryId,
      isPinned: isPinned ?? this.isPinned,
      isSynced: isSynced,
      isDeletedLocally: isDeletedLocally,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'remoteId': remoteId,
      'title': title,
      'content': content,
      'categoryId': categoryId,
      'isPinned': isPinned,
      'isSynced': isSynced,
      'isDeletedLocally': isDeletedLocally,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      remoteId: map['remoteId'],
      title: map['title'],
      content: map['content'],
      categoryId: map['categoryId'],
      isPinned: map['isPinned'],
      isSynced: map['isSynced'],
      isDeletedLocally: map['isDeletedLocally'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}