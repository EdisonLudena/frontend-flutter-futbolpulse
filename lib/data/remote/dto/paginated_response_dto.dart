class PaginatedResponseDto<T> {
  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  PaginatedResponseDto({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedResponseDto.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) =>
      PaginatedResponseDto(
        count: (json['count'] ?? 0) as int,
        next: json['next'] as String?,
        previous: json['previous'] as String?,
        results: (json['results'] as List?)
                ?.map((e) => fromJsonT(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}
