import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../../database.dart';
import '../../../../utils/connectivity_utils.dart';

class PoskoController extends GetxController {
  final RxList<Map<String, dynamic>> poskoList = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isOnline = true.obs;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('posko');
  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    loadPoskoData();
  }

  Future<void> loadPoskoData() async {
    try {
      isLoading.value = true;
      
      final hasInternet = await ConnectivityUtils.hasInternetConnection();
      isOnline.value = hasInternet;
      print('Posko: Internet connection status: ${hasInternet ? 'Online' : 'Offline'}');

      if (hasInternet) {
        await _loadFromFirebase();
      } else {
        print('Posko: No internet connection, loading from SQLite');
        await _loadFromSQLite();
      }
    } catch (e) {
      print('Posko: Error loading data: $e');
      print('Posko: Falling back to SQLite data');
      await _loadFromSQLite();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadFromFirebase() async {
    try {
      print('Posko: Starting Firebase data fetch');
      final event = await _databaseRef.once();
      final snapshot = event.snapshot;

      if (snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        print('Posko: Retrieved ${data.length} records from Firebase');
        List<Map<String, dynamic>> poskos = [];

        for (var entry in data.entries.toList()) {
          final poskoData = _processPoskoData(entry);
          if (poskoData != null) {
            poskos.add(poskoData);
          }
        }

        // Sync posko data to SQLite for offline use
        await _syncPoskoToSQLite(poskos);
        poskoList.value = poskos;
      } else {
        print('Posko: No data found in Firebase');
        poskoList.value = [];
      }
    } catch (e) {
      print('Posko: Error fetching from Firebase: $e');
      throw e;
    }
  }

  Map<String, dynamic>? _processPoskoData(MapEntry entry) {
    try {
      final key = entry.key;
      final value = entry.value;
      
      return {
        'id': key,
        'nama': value['nama'] ?? 'Tidak ada nama',
        'alamat': value['alamat'] ?? 'Tidak ada alamat',
        'kota': value['kota'] ?? '',
        'kodepos': value['kodepos'] ?? '',
        'status': value['status'] ?? 'Tidak aktif',
        'telepon': value['telepon'] ?? '',
        'instagram': value['instagram'] ?? '',
        'email': value['email'] ?? '',
        'latitude': value['latitude'] ?? 0.0,
        'longitude': value['longitude'] ?? 0.0,
      };
    } catch (e) {
      print('Posko: Error processing posko data: $e');
    }
    return null;
  }

  Future<void> _syncPoskoToSQLite(List<Map<String, dynamic>> poskos) async {
    try {
      // Implementasi ini harus disesuaikan dengan struktur tabel SQLite yang ada
      // Untuk sementara, kita hanya menampilkan log
      print('Posko: Syncing ${poskos.length} poskos to SQLite');
      // Implementasi sinkronisasi ke SQLite akan ditambahkan di sini
    } catch (e) {
      print('Posko: Error syncing to SQLite: $e');
    }
  }

  Future<void> _loadFromSQLite() async {
    try {
      print('Posko: Loading data from SQLite');
      // Implementasi ini harus disesuaikan dengan struktur tabel SQLite yang ada
      // Untuk sementara, kita hanya menampilkan log dan menggunakan data dummy
      poskoList.value = [
        {
          'id': 'dummy1',
          'nama': 'Posko Darurat 1',
          'alamat': 'Perumahan Permata Puri, Jl. Bukit Barisan Blok AIV No. 9, Bringin, Ngaliyan.',
          'kota': 'Kota Semarang',
          'kodepos': '50189',
          'status': 'BUKA 24 JAM',
          'telepon': '(024) 7628345 (08:00 - 16:00) / 115',
          'instagram': 'basarnas_jateng',
          'email': 'sar.semarang@basarnas.go.id',
          'latitude': -6.984034,
          'longitude': 110.409990,
        }
      ];
      print('Posko: Successfully loaded dummy data from SQLite');
    } catch (e) {
      print('Posko: Error loading from SQLite: $e');
      poskoList.value = [];
    }
  }

  Future<void> refreshData() async {
    await loadPoskoData();
  }
}
