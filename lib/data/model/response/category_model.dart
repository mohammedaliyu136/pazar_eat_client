class CategoryModel {
  int _id;
  String _name;
  int _parentId;
  int _status;
  String _createdAt;
  String _image;

  CategoryModel(
      {int id,
        String name,
        int parentId,
        int position,
        int status,
        String createdAt,
        String updatedAt,
        String image}) {
    this._id = id;
    this._name = name;
    this._parentId = parentId;
    this._status = status;
    this._createdAt = createdAt;
    this._image = image;
  }

  int get id => _id;
  String get name => _name;
  int get parentId => _parentId;
  int get status => _status;
  String get createdAt => _createdAt;
  String get image => _image;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _parentId = json['parent_id'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['parent_id'] = this._parentId;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['image'] = this._image;
    return data;
  }
}
