class BookDetails {
  final String? key;
  final String? title;
  final String? description;
  final List<String> subjects;
  final List<int> covers;
  final String? firstPublishDate;

  const BookDetails({
    this.key,
    this.title,
    this.description,
    this.subjects = const [],
    this.covers = const [],
    this.firstPublishDate,
  });

  factory BookDetails.fromJson(Map<String, dynamic> json) {
    return BookDetails(
      key: json['key'] as String?,
      title: json['title'] as String?,
      description: _parseDescription(json['description']),
      subjects: (json['subjects'] as List?)
              ?.map((e) => e?.toString() ?? '')
              .where((e) => e.isNotEmpty)
              .toList() ??
          const [],
      covers: (json['covers'] as List?)
              ?.map((e) => (e is int) ? e : int.tryParse(e.toString()) ?? -1)
              .where((e) => e > 0)
              .toList() ??
          const [],
      firstPublishDate: json['first_publish_date'] as String?,
    );
  }

  static String? _parseDescription(dynamic description) {
    if (description == null) return null;
    if (description is String) return description;
    if (description is Map && description['value'] is String) {
      return description['value'] as String;
    }
    return description.toString();
  }

  String? get largeCoverUrl => covers.isNotEmpty
      ? 'https://covers.openlibrary.org/b/id/${covers.first}-L.jpg'
      : null;
}


