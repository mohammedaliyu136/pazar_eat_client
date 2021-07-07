class ProductModel {
  int _totalSize;
  String _limit;
  String _offset;
  List<Product> _products;

  ProductModel(
      {int totalSize, String limit, String offset, List<Product> products}) {
    this._totalSize = totalSize;
    this._limit = limit;
    this._offset = offset;
    this._products = products;
  }

  int get totalSize => _totalSize;
  String get limit => _limit;
  String get offset => _offset;
  List<Product> get products => _products;

  ProductModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'];
    _offset = json['offset'];
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        //_products.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this._totalSize;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._products != null) {
      data['products'] = this._products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  String _id;
  String _name;
  String _description;
  String _image;
  double _price;
  List<AddOns> _addOns;
  String _availableTimeStarts;
  String _availableTimeEnds;
  int _status;
  String _createdAt;
  //List<CategoryId> _categoryIds;
  String _categoryId;
  //List<ChoiceOption> _choiceOptions;
  double _discount;
  String _discountType;
  String _restaurantId;
  double _rating;

  Product(
      {String id,
        String name,
        String description,
        String image,
        double price,
        List<AddOns> addOns,
        String availableTimeStarts,
        String availableTimeEnds,
        int status,
        String createdAt,
        String updatedAt,
        String categoryId,
        //List<ChoiceOption> choiceOptions,
        double discount,
        String discountType,
        String restaurantId,
        double rating}) {
    this._id = id;
    this._name = name;
    this._description = description;
    this._image = image;
    this._price = price;
    this._addOns = addOns;
    this._availableTimeStarts = availableTimeStarts;
    this._availableTimeEnds = availableTimeEnds;
    this._status = status;
    this._createdAt = createdAt;
    this._categoryId = categoryId;
    //this._choiceOptions = choiceOptions;
    this._discount = discount;
    this._discountType = discountType;
    this._rating = rating;
  }

  String get id => _id;
  String get name => _name;
  String get description => _description;
  String get image => _image;
  double get price => _price;
  List<AddOns> get addOns => _addOns;
  String get availableTimeStarts => _availableTimeStarts;
  String get availableTimeEnds => _availableTimeEnds;
  int get status => _status;
  String get createdAt => _createdAt;
  String get categoryId => _categoryId;
  //List<ChoiceOption> get choiceOptions => _choiceOptions;
  double get discount => _discount;
  String get discountType => _discountType;
  String get restaurantId => _restaurantId;
  double get rating => _rating;

  Product.fromJson({Map<String, dynamic> json, String id = ''}) {
    _id = id;
    _name = json['name'];
    _description = json['description'];
    _image = json['image_url'];
    _price = double.parse(json['price'].toString());
    print(json['add_ons'].toString()+' 000');
    if (json['add_ons'] != null) {
      _addOns = [];
      json['add_ons'].forEach((v) {
        _addOns.add(new AddOns.fromJson(v));
      });
    }
    _availableTimeStarts = json['available_time_starts'];
    _availableTimeEnds = json['available_time_ends'];
    _status = json['status'];
    _categoryId = json['category_id'];
    _discount = double.parse(json['discount'].toString());
    _discountType = json['discount_type'];
    _rating = 0;//double.parse(json['rating'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['description'] = this._description;
    data['image'] = this._image;
    data['price'] = this._price;
    if (this._addOns != null) {
      data['add_ons'] = this._addOns.map((v) => v.toJson()).toList();
    }
    data['available_time_starts'] = this._availableTimeStarts;
    data['available_time_ends'] = this._availableTimeEnds;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['category_id'] = this._categoryId;
    data['discount'] = this._discount;
    data['discount_type'] = this._discountType;
    data['restaurant_id'] = this._restaurantId;
    return data;
  }
}

class Variation {
  String _type;
  double _price;

  Variation({String type, double price}) {
    this._type = type;
    this._price = price;
  }

  String get type => _type;
  double get price => _price;

  Variation.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    if(json['price'] != null) {
      _price = json['price'].toDouble();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this._type;
    data['price'] = this._price;
    return data;
  }
}

class AddOns {
  int _id;
  String _name;
  double _price;
  String _createdAt;
  String _updatedAt;

  AddOns({int id, String name, double price, String createdAt, String updatedAt}) {
    this._id = id;
    this._name = name;
    this._price = price;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int get id => _id;
  String get name => _name;
  double get price => _price;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  AddOns.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _price = json['price'].toDouble();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['price'] = this._price;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}

class CategoryId {
  String _id;
  int _position;

  CategoryId({String id, int position}) {
    this._id = id;
    this._position = position;
  }

  String get id => _id;
  int get position => _position;

  CategoryId.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['position'] = this._position;
    return data;
  }
}

class ChoiceOption {
  String _name;
  String _title;
  List<String> _options;

  ChoiceOption({String name, String title, List<String> options}) {
    this._name = name;
    this._title = title;
    this._options = options;
  }

  String get name => _name;
  String get title => _title;
  List<String> get options => _options;

  ChoiceOption.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _title = json['title'];
    _options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['title'] = this._title;
    data['options'] = this._options;
    return data;
  }
}

class Rating {
  String _average;
  int _productId;

  Rating({String average, int productId}) {
    this._average = average;
    this._productId = productId;
  }

  String get average => _average;
  int get productId => _productId;

  Rating.fromJson(Map<String, dynamic> json) {
    _average = json['average'];
    _productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average'] = this._average;
    data['product_id'] = this._productId;
    return data;
  }
}