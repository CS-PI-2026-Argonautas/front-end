
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/models/os.dart';

class OrdemServicoRepository {
  final FirebaseFirestore _firestore;

  OrdemServicoRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('ordens_servico');

  Future<void> salvar(OrdemServico os) async {
    final referencia = _collection.doc(os.id);

    final documento = await referencia.get(
      const GetOptions(source: Source.serverAndCache),
    );

    final dados = os.toFirestore();

    if (documento.exists) {
      dados['updated_at'] = FieldValue.serverTimestamp();
      await referencia.set(
        dados,
        SetOptions(merge: true),
      );
    } else {
      dados['created_at'] = FieldValue.serverTimestamp();
      dados['updated_at'] = FieldValue.serverTimestamp();
      await referencia.set(dados);
    }
  }

  Future<OrdemServico?> buscarPorId(String id) async {
    final documento = await _collection.doc(id).get();

    if (!documento.exists) return null;

    
    throw UnimplementedError(
      'A leitura da OS será implementada na próxima etapa.',
    );
  }

  Future<void> deletarLogicamente(String id) async {
    await _collection.doc(id).update({
      'deleted_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
  }
}
