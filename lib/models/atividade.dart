class atividade {
  String id;
  String label;
  String dist;

  atividade({
    this.id,
    this.label,
  });

  factory atividade.fromJson(Map<String, dynamic> json) {
    return atividade(
      id: json['Id_Atividade'],
      label: json['Atividade'],
    );
  }

}