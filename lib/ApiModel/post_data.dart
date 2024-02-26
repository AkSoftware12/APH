import 'package:flutter/material.dart';

class PostData {
  final int id;
  final String file;
  final String fileType;
  final String title;
  final String description;
  final String postData;
  final List<Comment> comments;

  PostData({
    required this.id,
    required this.file,
    required this.fileType,
    required this.title,
    required this.description,
    required this.postData,
    required this.comments,
  });
}

class Comment {
  final int id;
  final int userId;
  final int postId;
  final String comment;
  final DateTime updatedAt;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.postId,
    required this.comment,
    required this.updatedAt,
    required this.createdAt,
  });
}
