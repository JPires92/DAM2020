class tipoOferta {
  String id;
  String label;
  String dist;

  tipoOferta({
    this.id,
    this.label,
  });

  factory tipoOferta.fromJson(Map<String, dynamic> json) {
    return tipoOferta(
      id: json['Id_TipoOferta'],
      label: json['Oferta'],
    );
  }

}