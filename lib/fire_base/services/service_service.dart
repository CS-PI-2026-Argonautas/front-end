import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/models/service.dart';

class ServicoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _colecao = 'services';

  Future<void> cadastrarServico(Service servico) async {
    try {
      await _firestore.collection(_colecao).add(servico.toMap());
    } catch (e) {
      throw Exception('Erro ao cadastrar serviço: $e');
    }
  }

  Future<List<Service>> buscarServicosDisponiveis() async {
    try {
      final snapshot = await _firestore.collection(_colecao).get();

      return snapshot.docs.map((doc) {
        return Service.fromMap(doc.data(), idDocumento: doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar serviços: $e');
    }
  }

  Future<void> atualizarServico(Service servico) async {
    final id = servico.id;

    if (id == null || id.isEmpty) {
      throw Exception('Serviço sem id: não é possível atualizar.');
    }

    try {
      await _firestore.collection(_colecao).doc(id).update(servico.toMap());
    } catch (e) {
      throw Exception('Erro ao atualizar serviço: $e');
    }
  }
}