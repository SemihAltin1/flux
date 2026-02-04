final class NoteModel {
  final int? id;
  final int? remoteId;
  final String? title;
  final String? content;
  final String? categoryId;
  final int? isPinned;
  final int? isSynced; // 0:Synced, 1:Created, 2:Updated,
  final int? isDeletedLocally;
  final String? createdAt;
  final String? updatedAt;

  const NoteModel({
    this.id,
    this.remoteId,
    this.title,
    this.content,
    this.categoryId,
    this.isPinned = 0,
    this.isSynced = 0,
    this.isDeletedLocally = 0,
    this.createdAt,
    this.updatedAt,
  });

  NoteModel copyWith({
    String? categoryId,
    String? updatedAt,
    int? isPinned,
    int? id,
    int? remoteId,
    int? isSynced,
  }) {
    return NoteModel(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      title: title,
      content: content,
      categoryId: categoryId ?? this.categoryId,
      isPinned: isPinned ?? this.isPinned,
      isSynced: isSynced ?? this.isSynced,
      isDeletedLocally: isDeletedLocally,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'remote_id': remoteId,
      'title': title ?? "",
      'content': content,
      'category_id': categoryId,
      'is_pinned': isPinned,
      'is_synced': isSynced,
      'is_deleted_locally': isDeletedLocally,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory NoteModel.fromLocalJson(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      remoteId: map['remote_id'],
      title: map['title'] ?? "",
      content: map['content'],
      categoryId: map['category_id'] ?? 0,
      isPinned: map['is_pinned'] ?? 0,
      isSynced: map['is_synced'],
      isDeletedLocally: map['is_deleted_locally'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  factory NoteModel.fromRemoteJson(Map<String, dynamic> map) {
    return NoteModel(
      remoteId: map['id'],
      title: map['title'] ?? "",
      content: map['content'],
      categoryId: map['category_id'] ?? 0,
      isPinned: map['is_pinned'] == true ? 1 : 0,
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}