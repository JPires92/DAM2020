// Model Class
class emprego {
  String id;
  String designacao;
  String descricao;
  String emailContacto;
  String estado;


  emprego({
    this.id,
    this.designacao,
    this.descricao,
    this.emailContacto,
    this.estado,
  });

  factory emprego.fromJson(Map<String, dynamic> json) {
    return emprego(
      id: json['Id_Emprego'],
      designacao: json['Designacao'],
      descricao: json['Descricao'],
      emailContacto: json['EmailContado'],
      estado: json['Estado'],
    );
  }

}