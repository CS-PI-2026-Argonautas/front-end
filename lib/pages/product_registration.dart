import 'package:flutter/material.dart';

class ProductRegistration extends StatelessWidget {
  const ProductRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product regist',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 217, 236, 241),

        body: Center(
          child: Container(
            width: 900,

            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Cadastro de produtos",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Voltar"),
                    ),
                  ],
                ),

                SizedBox(height: 30),

                Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 10.0,
                    ),
                    child: Form(
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Descrição do produto: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          //DESCRIÇÃO DO PRODUTO (O COMENTARIO É MEU NÃO IA)
                          TextField(
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: 'Tamanho, marca, peso Max...',

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Quantidade em estoque: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          //QUANTIDADE EM ESTOQUE (O COMENTARIO É MEU NÃO IA)
                          TextField(
                            decoration: InputDecoration(
                              hintText: '10',
                              prefixIcon: const Icon(Icons.numbers),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Quantidade miníma: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                          //QUANTIDADE MINIMA (O COMENTARIO É MEU NÃO IA)
                          TextField(
                            decoration: InputDecoration(
                              hintText: '10',
                              prefixIcon: const Icon(Icons.numbers),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      58,
                                      73,
                                      183,
                                    ),
                                    foregroundColor:
                                        Colors.white, // 👈 texto branco
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.save),
                                  label: const Text("Salvar"),
                                ),
                              ),

                              const SizedBox(width: 15),

                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black87,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.cancel),
                                  label: const Text("Cancelar"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
