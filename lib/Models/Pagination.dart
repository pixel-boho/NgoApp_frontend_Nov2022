class Pagination {
  int _page;
  int _perPage;
  int _totalItemsCount;
  int _totalPagesCount;
  bool _hasNextPage;

  Pagination(
      {int page,
      int perPage,
      int totalItemsCount,
      int totalPagesCount,
      bool hasNextPage}) {
    this._page = page;
    this._perPage = perPage;
    this._totalItemsCount = totalItemsCount;
    this._totalPagesCount = totalPagesCount;
    this._hasNextPage = hasNextPage;
  }

  int get page => _page;

  set page(int page) => _page = page;

  int get perPage => _perPage;

  set perPage(int perPage) => _perPage = perPage;

  int get totalItemsCount => _totalItemsCount;

  set totalItemsCount(int totalItemsCount) =>
      _totalItemsCount = totalItemsCount;

  int get totalPagesCount => _totalPagesCount;

  set totalPagesCount(int totalPagesCount) =>
      _totalPagesCount = totalPagesCount;

  bool get hasNextPage => _hasNextPage;

  set hasNextPage(bool hasNextPage) => _hasNextPage = hasNextPage;

  Pagination.fromJson(Map<String, dynamic> json) {
    dynamic pagenumber = json['page'];
    print(pagenumber.runtimeType);
    if (pagenumber is int) {
      _page = json['page'];
    } else {
      _page = int.parse(json['page']);
    }

    dynamic perPg = json['perPage'];
    print(perPg.runtimeType);
    if (perPg is int) {
      _perPage = json['perPage'];
    } else {
      _perPage = int.parse(json['perPage']);
    }

    dynamic totItemCount = json['totalItems'];
    print(totItemCount.runtimeType);
    if (totItemCount is int) {
      _totalItemsCount = json['totalItems'];
    } else {
      _totalItemsCount = int.parse(json['totalItems']);
    }

    dynamic totPgsCount = json['totalPages'];
    print(totPgsCount.runtimeType);
    if (totPgsCount is int) {
      _totalPagesCount = json['totalPages'];
    } else {
      _totalPagesCount = int.parse(json['totalPages']);
    }

    _hasNextPage = json['hasNextPage'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this._page;
    data['perPage'] = this._perPage;
    data['totalItems'] = this._totalItemsCount;
    data['totalPages'] = this._totalPagesCount;
    data['hasNextPage'] = this._hasNextPage;
    return data;
  }
}
