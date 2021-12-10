class CategoryData {
  final int id;
  final String name;
  final String image;
  final String nameArabic;
  CategoryData(
      {required this.id,
      required this.name,
      required this.image,
      required this.nameArabic});

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      nameArabic: json['name_arabic'],
    );
  }

}

class Album {
  final int id;
  final String name;
  final String image;
  final String nameArabic;

  Album({
required this.id,
      required this.name,
      required this.image,
      required this.nameArabic
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      nameArabic: json['name_arabic'],
    );
  }
}
