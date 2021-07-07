class BannerModel {
  String _id;
  String _title;
  String _image;
  String _foodItemId;
  String _createdAt;

  BannerModel(
      {String id,
        String title,
        String image,
        String foodItemId,
        int status,
        String createdAt}) {
    this._id = id;
    this._title = title;
    this._image = image;
    this._foodItemId = foodItemId;
    this._createdAt = createdAt;
  }

  String get id => _id;
  String get title => _title;
  String get image => _image;
  String get foodItemId => _foodItemId;
  String get createdAt => _createdAt;

  BannerModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
    _title = json['title'];
    _image = json['image'];
    _foodItemId = json['food_item_id'];
    _createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['title'] = this._title;
    data['image'] = this._image;
    data['food_item_id'] = this._foodItemId;
    data['created_at'] = this._createdAt;
    return data;
  }
}
