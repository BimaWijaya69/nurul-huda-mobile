class Guru {
  final int? id;
  final String? name;
  final String? kode_guru;
  final String? qr_activation;
  final String? device_id;

  Guru({
    this.id,
    this.name,
    this.kode_guru,
    this.qr_activation,
    this.device_id,
  });

  factory Guru.fromJson(Map<String, dynamic> json) {
    return Guru(
      id: json['id'],
      name: json['name'],
      kode_guru: json['kode_guru'],
      qr_activation: json['qr_activation'],
      device_id: json['device_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'kode_guru': kode_guru,
      'qr_activation': qr_activation,
      'device_id': device_id,
    };
  }
}
