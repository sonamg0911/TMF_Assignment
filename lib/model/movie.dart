class Movie {
  String name;
  List<String> tags;
  String details;
  List<String> links;
  String image;

  Movie({this.name, this.tags, this.details, this.links, this.image});

  Movie.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    tags = json['tags'].cast<String>();
    details = json['details'];
    links = json['links'].cast<String>();
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['tags'] = this.tags;
    data['details'] = this.details;
    data['links'] = this.links;
    data['image'] = this.image;
    return data;
  }
}