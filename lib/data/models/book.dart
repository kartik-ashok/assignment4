class Book {
  final int? numFound;
  final int? start;
  final bool? numFoundExact;
  final String? documentationUrl;
  final String? q;
  final List<BookDoc>? docs;

  Book({
    this.numFound,
    this.start,
    this.numFoundExact,
    this.documentationUrl,
    this.q,
    this.docs,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      numFound: json['numFound'],
      start: json['start'],
      numFoundExact: json['numFoundExact'],
      documentationUrl: json['documentation_url'],
      q: json['q'],
      docs: json['docs'] != null
          ? (json['docs'] as List).map((doc) => BookDoc.fromJson(doc)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numFound': numFound,
      'start': start,
      'numFoundExact': numFoundExact,
      'documentation_url': documentationUrl,
      'q': q,
      'docs': docs?.map((doc) => doc.toJson()).toList(),
    };
  }
}

class BookDoc {
  final String? title;
  final List<String>? authorName;
  final int? coverI;
  final String? coverImage;
  final String? key;
  final String? olid;
  final bool isFavorite;

  BookDoc({
    this.title,
    this.authorName,
    this.coverI,
    this.key,
    this.olid,
    this.isFavorite = false,
  }) : coverImage = coverI != null
           ? 'https://covers.openlibrary.org/b/id/$coverI-M.jpg'
           : null;

  factory BookDoc.fromJson(Map<String, dynamic> json) {
    return BookDoc(
      title: json['title'],
      authorName: json['author_name'] != null
          ? List<String>.from(json['author_name'])
          : null,
      coverI: json['cover_i'],
      key: json['key'],
      olid: json['olid'],
    );
  }

  factory BookDoc.fromDb(Map<String, dynamic> json) {
    return BookDoc(
      title: json['title'],
      authorName: json['author_name'] != null ? [json['author_name']] : null,
      coverI: json['cover_i'],
      key: json['book_key'],
      olid: json['olid'],
      isFavorite: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author_name': authorName?.join(', '),
      'cover_i': coverI,
      'key': key,
      'olid': olid,
    };
  }

  Map<String, dynamic> toDbMap() {
    return {
      'title': title ?? '',
      'author_name': authorName?.join(', ') ?? '',
      'cover_i': coverI ?? 0,
      'book_key': key ?? '',
      'olid': olid ?? '',
    };
  }

  BookDoc copyWith({
    String? title,
    List<String>? authorName,
    int? coverI,
    String? key,
    String? olid,
    bool? isFavorite,
  }) {
    return BookDoc(
      title: title ?? this.title,
      authorName: authorName ?? this.authorName,
      coverI: coverI ?? this.coverI,
      key: key ?? this.key,
      olid: olid ?? this.olid,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
