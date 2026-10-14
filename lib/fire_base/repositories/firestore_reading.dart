import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

const Duration _esperaServidor = Duration(seconds: 4);
const GetOptions _soCache = GetOptions(source: Source.cache);

Future<QuerySnapshot<Map<String, dynamic>>> lerComFallback(
  Query<Map<String, dynamic>> consulta,
) async {
  try {
    return await consulta.get().timeout(_esperaServidor);
  } on TimeoutException {
    return consulta.get(_soCache);
  } on FirebaseException {
    return consulta.get(_soCache);
  }
}

Future<DocumentSnapshot<Map<String, dynamic>>> lerDocumentoComFallback(
  DocumentReference<Map<String, dynamic>> referencia,
) async {
  try {
    return await referencia.get().timeout(_esperaServidor);
  } on TimeoutException {
    return referencia.get(_soCache);
  } on FirebaseException {
    return referencia.get(_soCache);
  }
}
