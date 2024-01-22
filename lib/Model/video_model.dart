/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

VideoModel videoModelFromJson(String str) => VideoModel.fromJson(json.decode(str));

String videoModelToJson(VideoModel data) => json.encode(data.toJson());

class VideoModel {
    VideoModel({
        required this.msg,
        required this.data,
        required this.success,
    });

    String msg;
    List<Datum> data;
    String success;

    factory VideoModel.fromJson(Map<dynamic, dynamic> json) => VideoModel(
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        success: json["success"],
    );

    Map<dynamic, dynamic> toJson() => {
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "success": success,
    };
}

class Datum {
    Datum({
        required this.filePath,
        required this.id,
        required this.video,
        required this.category,
    });

    String filePath;
    String id;
    String video;
    String category;

    factory Datum.fromJson(Map<dynamic, dynamic> json) => Datum(
        filePath: json["filePath"],
        id: json["_id"],
        video: json["video"],
        category: json["category"],
    );

    Map<dynamic, dynamic> toJson() => {
        "filePath": filePath,
        "_id": id,
        "video": video,
        "category": category,
    };
}
