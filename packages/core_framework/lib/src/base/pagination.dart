



class Pagination {
  int? page;
  int? count;
  int? lastPage;
  int? pageSize;
  int? size;
  int? totalItems;
  int? total;
  int? length;
  int? offset;
  int? totalRecord;
  String? search;
  String? minPrice;
  String? maxPrice;
  bool? stockStatus;
  bool? allVariationsHaveDiscount;
  bool? hasPrice;

  Pagination({
    this.page,
    this.count,
    this.lastPage,
    this.pageSize,
    this.size,
    this.totalItems,
    this.total,
    this.length,
    this.offset,
    this.totalRecord,
    this.search,
    this.minPrice,
    this.maxPrice,
    this.stockStatus,
    this.hasPrice,
  });

  factory Pagination.fromJson(dynamic json) {
    return Pagination(
      totalRecord: json['totalRecord'],
    );
  }

  factory Pagination.fromJsonForReport(dynamic json) {
    return Pagination(
      pageSize: json['numberOfElements'],
      page: json['number'],
      totalItems: json['totalElements'],
      total: json['totalPages'],
    );
  }

  Map<String, int?> toJson() {
    return {
      if (length != null) 'length': length,
      if (offset != null) 'offset': offset,
    };
  }


  Map<String, Object?> toQueryParameters() {
    return {
      if (page != null) 'page': page,
      if (pageSize != null) 'page_size': pageSize,
      if (size != null) 'size': pageSize,
      if (search != null) 'search': search,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
      if (stockStatus != null) 'stock_status': stockStatus,
      if (allVariationsHaveDiscount != null) 'all_variations_have_discount': allVariationsHaveDiscount,
      if (hasPrice != null) 'has_price': hasPrice,
    };
  }

// Pagination copyWith({int? page, int? pageSize, int? totalItems, int? total}) {
//   return Pagination(
//     page: page ?? this.page,
//     pageSize: pageSize ?? this.pageSize,
//     totalItems: totalItems ?? this.totalItems,
//     total: total ?? this.total,
//   );
// }
}
