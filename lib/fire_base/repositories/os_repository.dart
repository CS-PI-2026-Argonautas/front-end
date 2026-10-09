
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/models/os.dart';

class OrdemServicoRepository {
  final FirebaseFirestore _firestore;

  OrdemServicoRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('ordens_servico');

  Future<void> salvar(OrdemServico os) async {

    if (os.cliente.id.trim().isEmpty) {
      throw Exception('Selecione um cliente para a OS.');
    }

    if (os.enderecoServico.id.trim().isEmpty) {
      throw Exception('Selecione um endereço para a OS.');
    }

    if (os.relatorio.trim().length > 256) {
      throw Exception('O relatório deve ter no máximo 256 caracteres.');
    }

    if (os.valores.totalCentavos < 0) {
      throw Exception('O total da OS não pode ser negativo.');
    }

    final referencia = _collection.doc(os.id);
    final dados = os.toFirestore();

 
    if (os.createdAt == null) {
      dados['created_at'] = FieldValue.serverTimestamp();
    }

    dados['updated_at'] = FieldValue.serverTimestamp();

    await referencia.set(
      dados,
      SetOptions(merge: true),
    );
    os.createdAt ??= Timestamp.now();
  }

  Future<void> deletarLogicamente(String id) async {
    await _collection.doc(id).set({
      'deleted_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
