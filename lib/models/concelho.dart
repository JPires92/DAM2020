// Model Class
class concelho {
  String id;
  String label;
  String dist;

  concelho({
    this.id,
    this.label,
    this.dist,
  });

  factory concelho.fromJson(Map<String, dynamic> json) {
    return concelho(
        id: json['Id_Concelho'],
        label: json['Concelho'],
        dist: json['Id_Distrito'],
    );
  }

}