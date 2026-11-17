
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {

  // Alamat API CodeIgniter 4
  static String get baseUrl {
  if (kIsWeb) {
    // Flutter Web
    return 'http://localhost:8080/api/umkm';
  }

  // HP Android fisik melalui USB + ADB Reverse
  return 'http://localhost:8080/api/umkm';
  }

  // READ - Mengambil semua UMKM
  static Future<List<dynamic>> getUmkm() async {
    final response = await http.get(
      Uri.parse(baseUrl),
    );

    debugPrint('STATUS GET: ${response.statusCode}');
    debugPrint('RESPONSE GET: ${response.body}');

    if (response.statusCode == 200) {
      final hasil = jsonDecode(response.body);

      if (hasil['success'] == true) {
        return hasil['data'];
      }
    }

    throw Exception('Gagal mengambil data UMKM');
  }

  // CREATE - Menambahkan UMKM
  static Future<bool> tambahUmkm(
    String nama,
    String pemilik,
    String alamat,
    String kategori,
    String kontak,
  ) async {
    final data = {
      'nama_umkm': nama,
      'pemilik': pemilik,
      'alamat': alamat,
      'kategori': kategori,
      'kontak': kontak,
    };

    debugPrint('DATA POST: ${jsonEncode(data)}');
    debugPrint('URL POST: $baseUrl');

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));

      debugPrint('STATUS POST: ${response.statusCode}');
      debugPrint('RESPONSE POST: ${response.body}');

      if (response.statusCode == 201) {
        final hasil = jsonDecode(response.body);
        return hasil['success'] == true;
      }

      return false;
    } catch (e) {
      debugPrint('ERROR POST: $e');
      return false;
    }
  }

  // UPDATE - Mengubah data UMKM
  static Future<bool> updateUmkm(
    int id,
    String nama,
    String pemilik,
    String alamat,
    String kategori,
    String kontak,
  ) async {
    final data = {
      'nama_umkm': nama,
      'pemilik': pemilik,
      'alamat': alamat,
      'kategori': kategori,
      'kontak': kontak,
    };

    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    debugPrint('STATUS PUT: ${response.statusCode}');
    debugPrint('RESPONSE PUT: ${response.body}');

    if (response.statusCode == 200) {
      final hasil = jsonDecode(response.body);
      return hasil['success'] == true;
    }

    return false;
  }

  // DELETE - Menghapus UMKM
  static Future<bool> hapusUmkm(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Accept': 'application/json',
      },
    );

    debugPrint('STATUS DELETE: ${response.statusCode}');
    debugPrint('RESPONSE DELETE: ${response.body}');

    if (response.statusCode == 200) {
      final hasil = jsonDecode(response.body);
      return hasil['success'] == true;
    }

    return false;
  }
}
