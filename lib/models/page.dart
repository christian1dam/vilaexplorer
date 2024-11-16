class Page<T> {
  final List<T> content;
  final int totalPages;
  final int totalElements;

  Page({
    required this.content,
    required this.totalPages,
    required this.totalElements,
  });

  factory Page.fromMap(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return Page(
      content: (json['content'] as List<dynamic>)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
    );
  }
}
