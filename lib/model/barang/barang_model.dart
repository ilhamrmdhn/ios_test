class BarangModel {
  final String id;
  final String nama;
  final int hargaJual;
  final int stok;

  BarangModel({
    required this.id,
    required this.nama,
    required this.hargaJual,
    required this.stok,
  });

  factory BarangModel.fromMap(Map<String, dynamic> map, String id) {
    return BarangModel(
      id: id,
      nama: map['nama'] as String? ?? '',
      hargaJual: map['hargaJual'] as int? ?? 0,
      stok: map['stok'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'hargaJual': hargaJual,
      'stok': stok,
    };
  }
}