import 'package:cloud_firestore/cloud_firestore.dart';

class PoskoModel {
  final String id;
  final double latitude;
  final double longitude;
  final String alamat;
  final String lokasi;
  final String telepon;
  final String instagram;
  final String email;
  final bool isOpen24Hours;

  PoskoModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.alamat,
    required this.lokasi,
    required this.telepon,
    required this.instagram,
    required this.email,
    required this.isOpen24Hours,
  });

  // Convert Firestore document to Posko model
  factory PoskoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PoskoModel(
      id: doc.id,
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      alamat: data['alamat'] ?? '',
      lokasi: data['lokasi'] ?? '',
      telepon: data['telepon'] ?? '',
      instagram: data['instagram'] ?? '',
      email: data['email'] ?? '',
      isOpen24Hours: data['isOpen24Hours'] ?? false,
    );
  }

  // Convert Posko model to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'alamat': alamat,
      'lokasi': lokasi,
      'telepon': telepon,
      'instagram': instagram,
      'email': email,
      'isOpen24Hours': isOpen24Hours,
    };
  }
} 