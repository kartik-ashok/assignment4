// class Book {
//   int? numFound;
//   int? start;
//   bool? numFoundExact;
//   String? documentationUrl;
//   String? q;
//   // Null? offset;
//   List<Docs>? docs;

//   Book({
//     this.numFound,
//     this.start,
//     this.numFoundExact,
//     this.documentationUrl,
//     this.q,
//     // this.offset,
//     this.docs,
//   });

//   Book.fromJson(Map<String, dynamic> json) {
//     numFound = json['numFound'];
//     start = json['start'];
//     numFoundExact = json['numFoundExact'];
//     numFound = json['num_found'];
//     documentationUrl = json['documentation_url'];
//     q = json['q'];
//     // offset = json['offset'];
//     if (json['docs'] != null) {
//       docs = <Docs>[];
//       json['docs'].forEach((v) {
//         docs!.add(new Docs.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['numFound'] = this.numFound;
//     data['start'] = this.start;
//     data['numFoundExact'] = this.numFoundExact;
//     data['num_found'] = this.numFound;
//     data['documentation_url'] = this.documentationUrl;
//     data['q'] = this.q;
//     // data['offset'] = this.offset;
//     if (this.docs != null) {
//       data['docs'] = this.docs!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Docs {
//   List<String>? authorName;
//   int? coverI;
//   String? title;

//   Docs({this.authorName, this.coverI, this.title});

//   Docs.fromJson(Map<String, dynamic> json) {
//     authorName = json['author_name'].cast<String>();
//     coverI = json['cover_i'];
//     title = json['title'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['author_name'] = this.authorName;
//     data['cover_i'] = this.coverI;
//     data['title'] = this.title;
//     return data;
//   }
// }

class Book {
  int? numFound;
  int? start;
  bool? numFoundExact;
  String? documentationUrl;
  String? q;
  Null? offset;
  List<Docs>? docs;

  Book({
    this.numFound,
    this.start,
    this.numFoundExact,
    this.documentationUrl,
    this.q,
    this.offset,
    this.docs,
  });

  Book.fromJson(Map<String, dynamic> json) {
    numFound = json['numFound'];
    start = json['start'];
    numFoundExact = json['numFoundExact'];
    numFound = json['num_found'];
    documentationUrl = json['documentation_url'];
    q = json['q'];
    offset = json['offset'];
    if (json['docs'] != null) {
      docs = <Docs>[];
      json['docs'].forEach((v) {
        docs!.add(new Docs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numFound'] = this.numFound;
    data['start'] = this.start;
    data['numFoundExact'] = this.numFoundExact;
    data['num_found'] = this.numFound;
    data['documentation_url'] = this.documentationUrl;
    data['q'] = this.q;
    data['offset'] = this.offset;
    if (this.docs != null) {
      data['docs'] = this.docs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Docs {
  List<String>? authorName;
  int? coverI;
  String? title;

  Docs({this.authorName, this.coverI, this.title});

  Docs.fromJson(Map<String, dynamic> json) {
    authorName = json['author_name'].cast<String>();
    coverI = json['cover_i'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author_name'] = this.authorName;
    data['cover_i'] = this.coverI;
    data['title'] = this.title;
    return data;
  }
}
