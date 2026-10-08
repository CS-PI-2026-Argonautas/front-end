import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/fire_base/models/servico.dart';

class ServicoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _colecao = 'services';

  Future<void> cadastrarServico(Servico servico) async {
    try {
      await _firestore.collection(_colecao).add(servico.toMap());
    } catch (e) {
      throw Exception('Erro ao cadastrar serviço: $e');
    }
  }

  Future<List<Servico>> buscarServicosDisponiveis() async {
    try {
      final snapshot = await _firestore.collection(_colecao).get();

      return snapshot.docs.map((doc) {
        return Servico.fromMap(doc.data(), idDocumento: doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Erro ao buscar serviços: $e');
    }
  }
}
