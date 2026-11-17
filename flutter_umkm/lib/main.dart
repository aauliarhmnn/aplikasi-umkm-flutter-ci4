import 'package:flutter/material.dart';
import 'services/api_service.dart';

const ink = Color(0xFF20201D);
const paper = Color(0xFFF8F4E8);
const yellow = Color(0xFFFFD54A);
const mint = Color(0xFFB9DDBF);
const coral = Color(0xFFF4A99C);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UMKM Lokal',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: paper,
        colorScheme: ColorScheme.fromSeed(seedColor: yellow),
        fontFamily: 'Roboto',
      ),
      home: const HalamanUmkm(),
    );
  }
}

class HalamanUmkm extends StatefulWidget {
  const HalamanUmkm({super.key});

  @override
  State<HalamanUmkm> createState() => _HalamanUmkmState();
}

class _HalamanUmkmState extends State<HalamanUmkm> {
  late Future<List<dynamic>> dataUmkm;
  String pencarian = '';

  @override
  void initState() {
    super.initState();
    dataUmkm = ApiService.getUmkm();
  }

  void refreshData() {
    setState(() {
      dataUmkm = ApiService.getUmkm();
    });
  }

  void pesan(String teks) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(teks), backgroundColor: ink),
    );
  }

  BoxDecoration kotak(Color warna, {double radius = 12}) {
    return BoxDecoration(
      color: warna,
      border: Border.all(color: ink, width: 2),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: const [BoxShadow(color: ink, offset: Offset(4, 4))],
    );
  }

  Widget tombol(String teks, Color warna, VoidCallback? aksi,
      {IconData? ikon}) {
    return InkWell(
      onTap: aksi,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: kotak(warna, radius: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (ikon != null) ...[
              Icon(ikon, color: ink, size: 19),
              const SizedBox(width: 8),
            ],
            Text(teks,
                style: const TextStyle(
                    color: ink, fontWeight: FontWeight.w900, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Future<void> formUmkm({Map<String, dynamic>? umkm}) async {
    final berhasil = await showDialog<bool>(
      context: context,
      builder: (context) => FormUmkmDialog(umkm: umkm),
    );

    if (!mounted) return;
    if (berhasil == true) {
      refreshData();
      pesan(umkm == null
          ? 'Data berhasil ditambahkan'
          : 'Data berhasil diperbarui');
    }
  }

  Future<void> hapusUmkm(Map<String, dynamic> umkm) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: paper,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: ink, width: 3),
        ),
        title: const Text('HAPUS USAHA?',
            style: TextStyle(fontWeight: FontWeight.w900)),
        content: Text('Yakin ingin menghapus ${umkm['nama_umkm']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal', style: TextStyle(color: ink)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (konfirmasi != true) return;
    bool berhasil = false;
    try {
      berhasil = await ApiService.hapusUmkm(int.parse(umkm['id'].toString()));
    } catch (_) {
      berhasil = false;
    }
    if (!mounted) return;
    if (berhasil) refreshData();
    pesan(berhasil ? 'Data berhasil dihapus' : 'Gagal menghapus data');
  }

  Widget kartuUmkm(Map<String, dynamic> umkm, int nomor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18, right: 5),
      padding: const EdgeInsets.all(16),
      decoration: kotak(Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: nomor.isEven ? mint : yellow,
                  border: Border.all(color: ink, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.storefront_outlined, color: ink),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${umkm['nama_umkm']}',
                        style: const TextStyle(
                            color: ink, fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Text('Pemilik: ${umkm['pemilik']}',
                        style: const TextStyle(color: ink, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: ink, thickness: 1),
          const SizedBox(height: 6),
          Text('KATEGORI  /  ${umkm['kategori']}',
              style: const TextStyle(
                  fontSize: 12, color: ink, fontWeight: FontWeight.w800)),
          const SizedBox(height: 9),
          Row(children: [
            const Icon(Icons.place_outlined, size: 18, color: ink),
            const SizedBox(width: 7),
            Expanded(child: Text('${umkm['alamat']}',
                style: const TextStyle(color: ink))),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            const Icon(Icons.phone_outlined, size: 18, color: ink),
            const SizedBox(width: 7),
            Expanded(child: Text('${umkm['kontak']}',
                style: const TextStyle(color: ink))),
          ]),
          const SizedBox(height: 17),
          Row(children: [
            Expanded(child: tombol('EDIT', yellow, () => formUmkm(umkm: umkm),
                ikon: Icons.edit_outlined)),
            const SizedBox(width: 14),
            Expanded(child: tombol('HAPUS', coral, () => hapusUmkm(umkm),
                ikon: Icons.delete_outline)),
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: paper,
        surfaceTintColor: paper,
        title: const Text('UMKM LOKAL',
            style: TextStyle(
                fontSize: 19, fontWeight: FontWeight.w900,
                letterSpacing: -0.5, color: ink)),
        actions: [
          IconButton(onPressed: refreshData,
              tooltip: 'Muat ulang', icon: const Icon(Icons.refresh, color: ink)),
          const SizedBox(width: 8),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: SizedBox(height: 2, child: ColoredBox(color: ink)),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: FutureBuilder<List<dynamic>>(
            future: dataUmkm,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: ink));
              }
              if (snapshot.hasError) {
                return Center(child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Text('GAGAL MEMUAT DATA',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 10),
                    Text('${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    tombol('COBA LAGI', yellow, refreshData),
                  ]),
                ));
              }
              final semua = snapshot.data ?? [];
              final daftar = semua.where((item) {
                final data = Map<String, dynamic>.from(item);
                final kata = pencarian.toLowerCase();
                return '${data['nama_umkm']} ${data['kategori']} ${data['pemilik']}'
                    .toLowerCase().contains(kata);
              }).toList();
              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: kotak(yellow),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('USAHA DI SEKITAR KITA',
                            style: TextStyle(fontSize: 11,
                                fontWeight: FontWeight.w900, letterSpacing: 1)),
                        SizedBox(height: 8),
                        Text('Kenali usaha\nlokal.',
                            style: TextStyle(fontSize: 32, height: 1.05,
                                fontWeight: FontWeight.w900, color: ink)),
                        SizedBox(height: 10),
                        Text('Satu tempat untuk mencatat dan mengelola UMKM.',
                            style: TextStyle(fontSize: 14, color: ink)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    onChanged: (teks) => setState(() => pencarian = teks),
                    decoration: InputDecoration(
                      hintText: 'Cari nama, pemilik, atau kategori',
                      prefixIcon: const Icon(Icons.search, color: ink),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: ink, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: const BorderSide(color: ink, width: 3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('DAFTAR USAHA',
                          style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.w900, color: ink)),
                      Text('${daftar.length} USAHA',
                          style: const TextStyle(fontSize: 12,
                              fontWeight: FontWeight.w800, color: ink)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (daftar.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Center(child: Text(
                        semua.isEmpty ? 'Belum ada data UMKM' : 'Usaha tidak ditemukan',
                        style: const TextStyle(color: ink),
                      )),
                    ),
                  for (int i = 0; i < daftar.length; i++)
                    kartuUmkm(Map<String, dynamic>.from(daftar[i]), i),
                  const SizedBox(height: 12),
                  tombol('TAMBAH USAHA BARU', mint, () => formUmkm(),
                      ikon: Icons.add_circle_outline),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// Dialog terpisah agar controller dikelola oleh lifecycle widget sendiri.
class FormUmkmDialog extends StatefulWidget {
  final Map<String, dynamic>? umkm;

  const FormUmkmDialog({super.key, this.umkm});

  @override
  State<FormUmkmDialog> createState() => _FormUmkmDialogState();
}

class _FormUmkmDialogState extends State<FormUmkmDialog> {
  late final TextEditingController nama;
  late final TextEditingController pemilik;
  late final TextEditingController alamat;
  late final TextEditingController kategori;
  late final TextEditingController kontak;
  bool menyimpan = false;

  bool get edit => widget.umkm != null;

  @override
  void initState() {
    super.initState();
    nama = TextEditingController(text: widget.umkm?['nama_umkm']?.toString() ?? '');
    pemilik = TextEditingController(text: widget.umkm?['pemilik']?.toString() ?? '');
    alamat = TextEditingController(text: widget.umkm?['alamat']?.toString() ?? '');
    kategori = TextEditingController(text: widget.umkm?['kategori']?.toString() ?? '');
    kontak = TextEditingController(text: widget.umkm?['kontak']?.toString() ?? '');
  }

  @override
  void dispose() {
    nama.dispose();
    pemilik.dispose();
    alamat.dispose();
    kategori.dispose();
    kontak.dispose();
    super.dispose();
  }

  void pesan(String teks) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(teks), backgroundColor: ink),
    );
  }

  Future<void> simpan() async {
    if (menyimpan) return;
    if ([nama, pemilik, alamat, kategori, kontak]
        .any((controller) => controller.text.trim().isEmpty)) {
      pesan('Semua kolom harus diisi');
      return;
    }

    setState(() { menyimpan = true; });
    bool berhasil = false;
    try {
      if (edit) {
        berhasil = await ApiService.updateUmkm(
          int.parse(widget.umkm!['id'].toString()),
          nama.text, pemilik.text, alamat.text, kategori.text, kontak.text,
        );
      } else {
        berhasil = await ApiService.tambahUmkm(
          nama.text, pemilik.text, alamat.text, kategori.text, kontak.text,
        );
      }
    } catch (e) {
      debugPrint('Gagal menyimpan UMKM: $e');
    }

    if (!mounted) return;
    if (berhasil) {
      Navigator.of(context).pop(true);
    } else {
      setState(() { menyimpan = false; });
      pesan('Gagal menyimpan data');
    }
  }

  Widget input(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: ink),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: ink, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: ink, width: 3),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: paper,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: ink, width: 3),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 430),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(edit ? 'EDIT USAHA' : 'TAMBAH USAHA',
                style: const TextStyle(fontSize: 25,
                  fontWeight: FontWeight.w900, color: ink)),
              const SizedBox(height: 6),
              const Text('Lengkapi informasi usaha di bawah ini.',
                style: TextStyle(color: ink)),
              const SizedBox(height: 22),
              input('Nama UMKM', nama),
              input('Nama pemilik', pemilik),
              input('Alamat', alamat),
              input('Kategori', kategori),
              input('Kontak', kontak, keyboardType: TextInputType.phone),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: menyimpan ? null : () => Navigator.of(context).pop(false),
                    child: const Text('Batal', style: TextStyle(
                      color: ink, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: menyimpan ? null : simpan,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: yellow,
                        border: Border.all(color: ink, width: 2),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [BoxShadow(color: ink, offset: Offset(4, 4))],
                      ),
                      child: Text(menyimpan ? 'MENYIMPAN...' : 'SIMPAN',
                        style: const TextStyle(color: ink,
                          fontWeight: FontWeight.w900, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
