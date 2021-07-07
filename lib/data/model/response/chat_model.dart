class ChatModel {
  String _id;
  String _userId;
  String _restaurantId;
  String _message;
  String _reply;
  String _createdAt;
  String _image;

  ChatModel(
      {String id,
        String userId,
        String restaurantId,
        String message,
        String reply,
        String createdAt,
        String updatedAt,
        String checked,
        String image}) {
    this._id = id;
    this._userId = userId;
    this._restaurantId = restaurantId;
    this._message = message;
    this._reply = reply;
    this._createdAt = createdAt;
    this._image = image;
  }

  String get id => _id;
  String get userId => _userId;
  String get restaurantId => _restaurantId;
  String get message => _message;
  String get reply => _reply;
  String get createdAt => _createdAt;
  String get image => _image;

  ChatModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _restaurantId = json['restaurant_id'];
    _message = json['message'];
    _reply = json['reply'];
    _createdAt = json['created_at'];
    _image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['user_id'] = this._userId;
    data['restaurant_id'] = this._restaurantId;
    data['message'] = this._message;
    data['reply'] = this._reply;
    data['created_at'] = this._createdAt;
    data['image'] = this._image;
    return data;
  }
}