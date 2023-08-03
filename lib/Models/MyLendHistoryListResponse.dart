// class MyLendHistoryListResponse {
//   int _statusCode;
//   String _baseUrl;
//   List<MyLendListItem> _list;
//   int _page;
//   int _perPage;
//   bool _hasNextPage;
//   int _totalCount;
//   String _message;
//   bool _success;

//
//
//   MyLendListHistoryResponse(
//       {int statusCode,
//         String baseUrl,
//         List<MyLendListItem> list,
//         int page,
//         int perPage,
//         bool hasNextPage,
//         int totalCount,
//         String message,
//         bool success}) {
//     this._statusCode = statusCode;
//     this._baseUrl = baseUrl;
//     this._list = list;
//     this._page = page;
//     this._perPage = perPage;
//     this._hasNextPage = hasNextPage;
//     this._totalCount = totalCount;
//     this._message = message;
//     this._success = success;
//   }
//
//   int get statusCode => _statusCode;
//   set statusCode(int statusCode) => _statusCode = statusCode;
//   String get baseUrl => _baseUrl;
//   set baseUrl(String baseUrl) => _baseUrl = baseUrl;
//   List<MyLendListItem> get list => _list;
//   set list(List<MyLendListItem> list) => _list = list;
//   int get page => _page;
//   set page(int page) => _page = page;
//   int get perPage => _perPage;
//   set perPage(int perPage) => _perPage = perPage;
//   bool get hasNextPage => _hasNextPage;
//   set hasNextPage(bool hasNextPage) => _hasNextPage = hasNextPage;
//   int get totalCount => _totalCount;
//   set totalCount(int totalCount) => _totalCount = totalCount;
//   String get message => _message;
//   set message(String message) => _message = message;
//   bool get success => _success;
//   set success(bool success) => _success = success;
//
//   MyLendHistoryListResponse.fromJson(Map<String, dynamic> json) {
//     _statusCode = json['statusCode'];
//     _baseUrl = json['baseUrl'];
//     if (json['list'] != null) {
//       _list = [];
//       json['list'].forEach((v) {
//         _list.add(new MyLendListItem.fromJson(v));
//       });
//     }
//     _page = json['page'];
//     _perPage = json['perPage'];
//     _hasNextPage = json['hasNextPage'];
//     _totalCount = json['totalCount'];
//     _message = json['message'];
//     _success = json['success'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['statusCode'] = this._statusCode;
//     data['baseUrl'] = this._baseUrl;
//     if (this._list != null) {
//       data['list'] = this._list.map((v) => v.toJson()).toList();
//     }
//     data['page'] = this._page;
//     data['perPage'] = this._perPage;
//     data['hasNextPage'] = this._hasNextPage;
//     data['totalCount'] = this._totalCount;
//     data['message'] = this._message;
//     data['success'] = this._success;
//     return data;
//   }
// }
//
// class MyLendListItem {
//   int _id;
//   int _userId;
//   int _loanId;
//   int _amount;
//   String _title;
//   String _purpose;
//   String _loanAmount;
//   String _imageUrl;

//
//
//   MyLendListItem(
//       {int id,
//         int userId,
//         int loanId,
//         int amount,
//         String title,
//         String purpose,
//         String loanAmount,
//         String imageUrl}) {
//     this._id = id;
//     this._userId = userId;
//     this._loanId = loanId;
//     this._amount = amount;
//     this._title = title;
//     this._purpose = purpose;
//     this._loanAmount = loanAmount;
//     this._imageUrl = imageUrl;
//   }
//
//   int get id => _id;
//   set id(int id) => _id = id;
//   int get userId => _userId;
//   set userId(int userId) => _userId = userId;
//   int get loanId => _loanId;
//   set loanId(int loanId) => _loanId = loanId;
//   int get amount => _amount;
//   set amount(int amount) => _amount = amount;
//   String get title => _title;
//   set title(String title) => _title = title;
//   String get purpose => _purpose;
//   set purpose(String purpose) => _purpose = purpose;
//   String get loanAmount => _loanAmount;
//   set loanAmount(String loanAmount) => _loanAmount = loanAmount;
//   String get imageUrl => _imageUrl;
//   set imageUrl(String imageUrl) => _imageUrl = imageUrl;
//
//   MyLendListItem.fromJson(Map<String, dynamic> json) {
//     _id = json['id'];
//     _userId = json['user_id'];
//     _loanId = json['loan_id'];
//     _amount = json['amount'];
//     _title = json['title'];
//     _purpose = json['purpose'];
//     _loanAmount = json['loan_amount'];
//     _imageUrl = json['image_url'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this._id;
//     data['user_id'] = this._userId;
//     data['loan_id'] = this._loanId;
//     data['amount'] = this._amount;
//     data['title'] = this._title;
//     data['purpose'] = this._purpose;
//     data['loan_amount'] = this._loanAmount;
//     data['image_url'] = this._imageUrl;
//     return data;
//   }
// }

class MyLendHistoryListResponse {
  int statusCode;
  String baseUrl;
  String webBaseUrl;
  List<MyLendListItem> list;
  int page;
  int perPage;
  bool hasNextPage;
  int totalCount;
  String message;
  bool success;

  MyLendHistoryListResponse(
      {this.statusCode,
        this.baseUrl,
        this.webBaseUrl,
        this.list,
        this.page,
        this.perPage,
        this.hasNextPage,
        this.totalCount,
        this.message,
        this.success});

  MyLendHistoryListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    baseUrl = json['baseUrl'];
    webBaseUrl = json['webBaseUrl'];
    if (json['list'] != null) {
      list = <MyLendListItem>[];
      json['list'].forEach((v) {
        list.add(new MyLendListItem.fromJson(v));
      });
    }
    page = json['page'];
    perPage = json['perPage'];
    hasNextPage = json['hasNextPage'];
    totalCount = json['totalCount'];
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['baseUrl'] = this.baseUrl;
    data['webBaseUrl'] = this.webBaseUrl;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    data['perPage'] = this.perPage;
    data['hasNextPage'] = this.hasNextPage;
    data['totalCount'] = this.totalCount;
    data['message'] = this.message;
    data['success'] = this.success;
    return data;
  }
}

class MyLendListItem {
  int id;
  int userId;
  int loanId;
  int amount;
  String title;
  String purpose;
  int loanAmount;
  String imageUrl;

  MyLendListItem(
      {this.id,
        this.userId,
        this.loanId,
        this.amount,
        this.title,
        this.purpose,
        this.loanAmount,
        this.imageUrl});

  MyLendListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    loanId = json['loan_id'];
    amount = json['amount'];
    title = json['title'];
    purpose = json['purpose'];
    loanAmount = json['loan_amount'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['loan_id'] = this.loanId;
    data['amount'] = this.amount;
    data['title'] = this.title;
    data['purpose'] = this.purpose;
    data['loan_amount'] = this.loanAmount;
    data['image_url'] = this.imageUrl;
    return data;
  }
}