class ReadBook {
  String? title;
  String? key;
  List<Authors>? authors;
  Author? type;
  String? description;
  List<int>? covers;
  List<String>? subjectPlaces;
  List<String>? subjects;
  List<String>? subjectPeople;
  List<String>? subjectTimes;
  String? location;
  int? latestRevision;
  int? revision;
  Created? created;
  Created? lastModified;

  ReadBook({
    this.title,
    this.key,
    this.authors,
    this.type,
    this.description,
    this.covers,
    this.subjectPlaces,
    this.subjects,
    this.subjectPeople,
    this.subjectTimes,
    this.location,
    this.latestRevision,
    this.revision,
    this.created,
    this.lastModified,
  });

  ReadBook.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    key = json['key'];
    if (json['authors'] != null) {
      authors = <Authors>[];
      json['authors'].forEach((v) {
        authors!.add(new Authors.fromJson(v));
      });
    }
    type = json['type'] != null ? new Author.fromJson(json['type']) : null;
    description = json['description'];
    covers = json['covers'].cast<int>();
    subjectPlaces = json['subject_places'].cast<String>();
    subjects = json['subjects'].cast<String>();
    subjectPeople = json['subject_people'].cast<String>();
    subjectTimes = json['subject_times'].cast<String>();
    location = json['location'];
    latestRevision = json['latest_revision'];
    revision = json['revision'];
    created = json['created'] != null
        ? new Created.fromJson(json['created'])
        : null;
    lastModified = json['last_modified'] != null
        ? new Created.fromJson(json['last_modified'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['key'] = this.key;
    if (this.authors != null) {
      data['authors'] = this.authors!.map((v) => v.toJson()).toList();
    }
    if (this.type != null) {
      data['type'] = this.type!.toJson();
    }
    data['description'] = this.description;
    data['covers'] = this.covers;
    data['subject_places'] = this.subjectPlaces;
    data['subjects'] = this.subjects;
    data['subject_people'] = this.subjectPeople;
    data['subject_times'] = this.subjectTimes;
    data['location'] = this.location;
    data['latest_revision'] = this.latestRevision;
    data['revision'] = this.revision;
    if (this.created != null) {
      data['created'] = this.created!.toJson();
    }
    if (this.lastModified != null) {
      data['last_modified'] = this.lastModified!.toJson();
    }
    return data;
  }
}

class Authors {
  Author? author;
  Author? type;

  Authors({this.author, this.type});

  Authors.fromJson(Map<String, dynamic> json) {
    author = json['author'] != null
        ? new Author.fromJson(json['author'])
        : null;
    type = json['type'] != null ? new Author.fromJson(json['type']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    if (this.type != null) {
      data['type'] = this.type!.toJson();
    }
    return data;
  }
}

class Author {
  String? key;

  Author({this.key});

  Author.fromJson(Map<String, dynamic> json) {
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    return data;
  }
}

class Created {
  String? type;
  String? value;

  Created({this.type, this.value});

  Created.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}
