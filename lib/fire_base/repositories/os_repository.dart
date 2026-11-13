import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/fire_base/models/os.dart';
import 'package:frontend/fire_base/repositories/firestore_reading.dart';

abstract class OsRepository {
  Future<List<ServiceOrder>> listarTodos();

  Future<void> salvar(ServiceOrder os);

  Future<void> deletar(int id);
}
