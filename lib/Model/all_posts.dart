
class AllPostModel {

  String? id;
  final String type;
  String? postId;
  String? ownerId;
  String? username;
  String? location;
  String? description;
  String? mediaUrl;
  DateTime? timestamp;
  final String userImage;
  final String userName;
  final String image;
  final String title;
  final String comment;
  final String url;
  bool isLiked;

  AllPostModel( {
    required this.id,
    required this.type,
    required this.userImage,
    required this.userName,
    required this.image,
    required this.title,
    required this.comment,
    required this.url,
    this.isLiked = false,
  });
}
