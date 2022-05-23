class CompanyModel {
  int? pages;
  List<CompanyCountry>? companyCountry;
  List<CompanyData>? data;
  String? msg;
  int? status;

  CompanyModel({this.pages, this.companyCountry, this.data, this.msg, this.status});

  CompanyModel.fromJson(Map<String, dynamic> json) {
    pages = json['pages'];
    if (json['country'] != null) {
      companyCountry = <CompanyCountry>[];
      json['country'].forEach((v) {
        companyCountry!.add(new CompanyCountry.fromJson(v));
      });
    }
    if (json['data'] != null) {
      data = <CompanyData>[];
      json['data'].forEach((v) {
        data!.add(new CompanyData.fromJson(v));
      });
    }
    msg = json['msg'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pages'] = this.pages;
    if (this.companyCountry != null) {
      data['country'] = this.companyCountry!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['msg'] = this.msg;
    data['status'] = this.status;
    return data;
  }
}

class CompanyCountry {
  String? firstCountry;

  CompanyCountry({this.firstCountry});

  CompanyCountry.fromJson(Map<String, dynamic> json) {
    firstCountry = json['first_country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_country'] = this.firstCountry;
    return data;
  }
}

class CompanyData {
  String? id;
  String? companyName;
  String? firstCountry;
  String? secondCountry;
  String? websiteLink;
  String? wikiPage;
  String? sector;
  String? companyLogo;
  String? madeInIndia;
  String? aboutCompany;
  String? story;
  String? isActive;
  String? isService;
  String? ratings;
  String? addedbyName;
  String? addedbyPlace;
  String? addedbyPhoto;
  String? moderatorName;
  String? moderatorPlace;
  String? moderatorPhoto;
  String? dateAdded;
  String? dateUpdated;

  CompanyData(
      {this.id,
        this.companyName,
        this.firstCountry,
        this.secondCountry,
        this.websiteLink,
        this.wikiPage,
        this.sector,
        this.companyLogo,
        this.madeInIndia,
        this.aboutCompany,
        this.story,
        this.isActive,
        this.isService,
        this.ratings,
        this.addedbyName,
        this.addedbyPlace,
        this.addedbyPhoto,
        this.moderatorName,
        this.moderatorPlace,
        this.moderatorPhoto,
        this.dateAdded,
        this.dateUpdated});

  CompanyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    firstCountry = json['first_country'];
    secondCountry = json['second_country'];
    websiteLink = json['website_link'];
    wikiPage = json['wiki_page'];
    sector = json['sector'];
    companyLogo = json['company_logo'];
    madeInIndia = json['made_in_india'];
    aboutCompany = json['about_company'];
    story = json['story'];
    isActive = json['is_active'];
    isService = json['is_service'];
    ratings = json['ratings'];
    addedbyName = json['addedby_name'];
    addedbyPlace = json['addedby_place'];
    addedbyPhoto = json['addedby_photo'];
    moderatorName = json['moderator_name'];
    moderatorPlace = json['moderator_place'];
    moderatorPhoto = json['moderator_photo'];
    dateAdded = json['date_added'];
    dateUpdated = json['date_updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_name'] = this.companyName;
    data['first_country'] = this.firstCountry;
    data['second_country'] = this.secondCountry;
    data['website_link'] = this.websiteLink;
    data['wiki_page'] = this.wikiPage;
    data['sector'] = this.sector;
    data['company_logo'] = this.companyLogo;
    data['made_in_india'] = this.madeInIndia;
    data['about_company'] = this.aboutCompany;
    data['story'] = this.story;
    data['is_active'] = this.isActive;
    data['is_service'] = this.isService;
    data['ratings'] = this.ratings;
    data['addedby_name'] = this.addedbyName;
    data['addedby_place'] = this.addedbyPlace;
    data['addedby_photo'] = this.addedbyPhoto;
    data['moderator_name'] = this.moderatorName;
    data['moderator_place'] = this.moderatorPlace;
    data['moderator_photo'] = this.moderatorPhoto;
    data['date_added'] = this.dateAdded;
    data['date_updated'] = this.dateUpdated;
    return data;
  }
}