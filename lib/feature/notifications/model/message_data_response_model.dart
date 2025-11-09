import 'package:json_annotation/json_annotation.dart';
part 'message_data_response_model.g.dart';
@JsonSerializable()
class MessageData {
  final String? imageUrl;
  final String? type;
  final String? title;
  @JsonKey(name: 'body')
  final String? message;

  MessageData({
    this.imageUrl,
    this.type,
    this.title,
    this.message,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) =>
      _$MessageDataFromJson(json);

  Map<String, dynamic> toJson() => _$MessageDataToJson(this);

  MessageData copyWith({
    String? imageUrl,
    String? type,
    String? title,
    String? message,
  }) {
    return MessageData(
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
    );
  }
}
