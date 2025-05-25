import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/posko_model.dart';
import 'package:firebase_core/firebase_core.dart';

class PoskoService {
  late FirebaseFirestore _firestore;
  final String _collection = 'posko';
  bool _initialized = false;

  PoskoService() {
    _initializeFirestore();
  }

  // Initialize Firestore
  Future<void> _initializeFirestore() async {
    if (!_initialized) {
      try {
        _firestore = FirebaseFirestore.instance;
        _initialized = true;
        print('Firestore initialized successfully');
      } catch (e) {
        print('Failed to initialize Firestore: $e');
      }
    }
  }

  // Get all posko
  Stream<List<PoskoModel>> getPoskos() async* {
    await _initializeFirestore();
    
    yield* _firestore
        .collection(_collection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PoskoModel.fromFirestore(doc))
            .toList());
  }

  // Get a single posko by ID
  Future<PoskoModel?> getPoskoById(String id) async {
    await _initializeFirestore();
    
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (doc.exists) {
      return PoskoModel.fromFirestore(doc);
    }
    return null;
  }

  // Add a new posko
  Future<String> addPosko(PoskoModel posko) async {
    await _initializeFirestore();
    
    final docRef = await _firestore.collection(_collection).add(posko.toFirestore());
    return docRef.id;
  }

  // Update an existing posko
  Future<void> updatePosko(String id, PoskoModel posko) async {
    await _initializeFirestore();
    
    await _firestore.collection(_collection).doc(id).update(posko.toFirestore());
  }

  // Delete a posko
  Future<void> deletePosko(String id) async {
    await _initializeFirestore();
    
    await _firestore.collection(_collection).doc(id).delete();
  }

  // Add sample data to Firestore (use this once to populate your database)
  Future<void> addSamplePoskos() async {
    await _initializeFirestore();
    
    try {
      // Check if collection exists and has data
      final snapshot = await _firestore.collection(_collection).limit(1).get();
      
      // Only add sample data if collection is empty
      if (snapshot.docs.isEmpty) {
        // Sample posko data
        final poskos = [
          {
            'latitude': -6.984034,
            'longitude': 110.409990,
            'alamat': 'Perumahan Permata Puri, Jl. Bukit Barisan Blok AIV No. 9, Bringin, Ngaliyan.',
            'lokasi': 'Kota Semarang, 50189',
            'telepon': '(024) 7628345 (08:00 - 16:00) / 115',
            'instagram': 'basarnas_jateng',
            'email': 'sar.semarang@basarnas.go.id',
            'isOpen24Hours': true,
          },
          {
            'latitude': -6.983470, 
            'longitude': 110.421200,
            'alamat': 'Jl. Dr. Wahidin No. 54, Jatingaleh, Candisari',
            'lokasi': 'Kota Semarang, 50254',
            'telepon': '(024) 8311685',
            'instagram': 'bpbdjateng',
            'email': 'bpbd.jateng@gmail.com',
            'isOpen24Hours': true,
          },
          {
            'latitude': -6.996830, 
            'longitude': 110.430199,
            'alamat': 'Jl. Madukoro Blok BB No. 5-7, Krobokan, Semarang Barat',
            'lokasi': 'Kota Semarang, 50144',
            'telepon': '(024) 7608754',
            'instagram': 'pmi_kotasemarang',
            'email': 'pmisemarang@pmi.or.id',
            'isOpen24Hours': false,
          },
        ];

        // Add sample data
        for (var poskoData in poskos) {
          await _firestore.collection(_collection).add(poskoData);
        }
        
        print('Sample posko data added successfully');
      } else {
        print('Collection already contains data, skipping sample data addition');
      }
    } catch (e) {
      print('Error adding sample posko data: $e');
    }
  }
} 