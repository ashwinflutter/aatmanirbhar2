class ProductModel {
  int? pages;
  List<ProductCountry>? productCountry;
  List<ProductData>? data;
  String? msg;
  int? status;

  ProductModel({this.pages, this.productCountry, this.data, this.msg, this.status});

  ProductModel.fromJson(Map<String, dynamic> json) {
    pages = json['pages'];
    if (json['country'] != null) {
      productCountry = <ProductCountry>[];
      json['country'].forEach((v) {
        productCountry!.add(new ProductCountry.fromJson(v));
      });
    }
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data!.add(new ProductData.fromJson(v));
      });
    }
    msg = json['msg'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pages'] = this.pages;
    if (this.productCountry != null) {
      data['country'] = this.productCountry!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['msg'] = this.msg;
    data['status'] = this.status;
    return data;
  }
}

class ProductCountry {
  String? firstCountry;

  ProductCountry({this.firstCountry});

  ProductCountry.fromJson(Map<String, dynamic> json) {
    firstCountry = json['first_country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_country'] = this.firstCountry;
    return data;
  }
}

class ProductData {
  String? companyId;
  String? productName;
  String? firstCountry;
  String? secondCountry;
  String? websiteLink;
  String? manufacture;
  String? keywords;
  String? madeInIndia;
  String? rating;
  String? image;
  String? isActive;
  String? addedbyName;
  String? addedbyPlace;
  String? addedbyPhoto;
  String? dateAdded;
  String? moderatorName;
  String? moderatorPlace;
  String? moderatorPhoto;
  String? dateUpdated;

  ProductData(
      {this.companyId,
        this.productName,
        this.firstCountry,
        this.secondCountry,
        this.websiteLink,
        this.manufacture,
        this.keywords,
        this.madeInIndia,
        this.rating,
        this.image,
        this.isActive,
        this.addedbyName,
        this.addedbyPlace,
        this.addedbyPhoto,
        this.dateAdded,
        this.moderatorName,
        this.moderatorPlace,
        this.moderatorPhoto,
        this.dateUpdated});

  ProductData.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    productName = json['product_name'];
    firstCountry = json['first_country'];
    secondCountry = json['second country'];
    websiteLink = json['website_link'];
    manufacture = json['manufacture'];
    keywords = json['keywords'];
    madeInIndia = json['made_in_india'];
    rating = json['rating'];
    image = json['image'];
    isActive = json['is_active'];
    addedbyName = json['addedby_name'];
    addedbyPlace = json['addedby_place'];
    addedbyPhoto = json['addedby_photo'];
    dateAdded = json['date_added'];
    moderatorName = json['moderator_name'];
    moderatorPlace = json['moderator_place'];
    moderatorPhoto = json['moderator_photo'];
    dateUpdated = json['date_updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId;
    data['product_name'] = this.productName;
    data['first_country'] = this.firstCountry;
    data['second country'] = this.secondCountry;
    data['website_link'] = this.websiteLink;
    data['manufacture'] = this.manufacture;
    data['keywords'] = this.keywords;
    data['made_in_india'] = this.madeInIndia;
    data['rating'] = this.rating;
    data['image'] = this.image;
    data['is_active'] = this.isActive;
    data['addedby_name'] = this.addedbyName;
    data['addedby_place'] = this.addedbyPlace;
    data['addedby_photo'] = this.addedbyPhoto;
    data['date_added'] = this.dateAdded;
    data['moderator_name'] = this.moderatorName;
    data['moderator_place'] = this.moderatorPlace;
    data['moderator_photo'] = this.moderatorPhoto;
    data['date_updated'] = this.dateUpdated;
    return data;
  }
}