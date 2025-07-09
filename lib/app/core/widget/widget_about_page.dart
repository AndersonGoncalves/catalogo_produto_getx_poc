import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:catalogo_produto_poc/app/core/ui/theme_extensions.dart';
import 'package:catalogo_produto_poc/app/core/ui/url_launcher.dart';

class WidgetAboutPage extends StatefulWidget {
  final bool _comAppBar;
  const WidgetAboutPage({super.key, bool comAppBar = true})
    : _comAppBar = comAppBar;

  @override
  State<WidgetAboutPage> createState() => _WidgetAboutPageState();
}

class _WidgetAboutPageState extends State<WidgetAboutPage> {
  String _version = '';

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.canvasColor,
      appBar: widget._comAppBar
          ? AppBar(
              centerTitle: true,
              elevation: 0,
              toolbarHeight: 56,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: Navigator.of(context).pop,
                icon: const Icon(Icons.close),
              ),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text('Sobre'),
              ),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset('assets/icon/icon-adaptive.png'),
                ),
                Text(
                  'PoC',
                  style: TextStyle(
                    fontSize: 30,
                    color: context.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_offer_outlined,
                            color: context.primaryColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                            child: Text(
                              'Catálogo de Produtos',
                              style: TextStyle(
                                fontSize: 20,
                                color: context.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Aplicativo de cadastro e gerenciamento de produtos com possibilidadede inclusão no carrinho de compras, desenvolvido por Anderson Gonçalves como uma prova de conceito utilizando Flutter, Dart e Firebase.',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.primaryColor,
                        ),
                        textAlign: TextAlign.justify,
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons.paste_rounded,
                            color: context.primaryColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                            child: Text(
                              'Descrição',
                              style: TextStyle(
                                fontSize: 20,
                                color: context.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Este app permite que usuários cadastrem, visualizem e gerenciem produtos. É possível adicionar até três fotos para cada produto e o acesso do usuário ao app pode ser feito de forma anônima ou autenticando-se via e-mail. O usuário também pode incluir os produtos no carrinho e finalizar uma compra. Todos os dados de produtos e autenticação são gerenciados via Firebase.',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.primaryColor,
                        ),
                        textAlign: TextAlign.justify,
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons.phone_android,
                            color: context.primaryColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                            child: Text(
                              'Tecnologias Utilizadas',
                              style: TextStyle(
                                fontSize: 20,
                                color: context.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          '1 - Frontend',
                          style: TextStyle(
                            fontSize: 16,
                            color: context.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 7, left: 10),
                        child: InkWell(
                          onTap: () {
                            UrlLauncher.openUrl('https://flutter.dev/');
                          },
                          child: Text(
                            '1.1 - Flutter (Framework)',
                            style: TextStyle(
                              fontSize: 14,
                              color: context.primaryColor,
                              // decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 7, left: 10),
                        child: InkWell(
                          onTap: () {
                            UrlLauncher.openUrl('https://dart.dev/');
                          },
                          child: Text(
                            '1.2 - Dart (Linguagem)',
                            style: TextStyle(
                              fontSize: 14,
                              color: context.primaryColor,
                              // decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 7, left: 10),
                        child: InkWell(
                          onTap: () {
                            UrlLauncher.openUrl(
                              'https://pub.dev/packages/provider',
                            );
                          },
                          child: Text(
                            '1.3 - Provider (Provedor de gerência de estado)',
                            style: TextStyle(
                              fontSize: 14,
                              color: context.primaryColor,
                              // decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          '2 - Backend',
                          style: TextStyle(
                            fontSize: 16,
                            color: context.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7, left: 10),
                        child: InkWell(
                          onTap: () {
                            UrlLauncher.openUrl(
                              'https://firebase.google.com/products/realtime-database?hl=pt-br',
                            );
                          },
                          child: Text(
                            '2.1 - Realtime Database (armazenamento dos produtos)',
                            style: TextStyle(
                              fontSize: 14,
                              color: context.primaryColor,
                              // decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7, left: 10),
                        child: InkWell(
                          onTap: () {
                            UrlLauncher.openUrl(
                              'https://firebase.google.com/products/auth?hl=pt-br',
                            );
                          },
                          child: Text(
                            '1.2 - Firebase Authentication (autenticação anônima e por e-mail)',
                            style: TextStyle(
                              fontSize: 14,
                              color: context.primaryColor,
                              // decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          Icon(Icons.functions, color: context.primaryColor),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                            child: Text(
                              'Funcionalidades',
                              style: TextStyle(
                                fontSize: 20,
                                color: context.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '- Listagem de produtos cadastrados.',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.primaryColor,
                        ),
                      ),
                      Text(
                        '- Inclusão do produto no carrinho de compras.',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.primaryColor,
                        ),
                      ),
                      Text(
                        '- Cadastro/edição de produto.',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.primaryColor,
                        ),
                      ),
                      Text(
                        '- Upload e exibição de fotos dos produtos.',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.primaryColor,
                        ),
                      ),
                      Text(
                        '- Integração em tempo real com Firebase.',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.primaryColor,
                        ),
                      ),

                      Row(
                        children: [
                          Icon(Icons.home, color: context.primaryColor),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                            child: Text(
                              'Estrutura do Projeto',
                              style: TextStyle(
                                fontSize: 20,
                                color: context.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '- lib/ (Código principal do Flutter)',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.primaryColor,
                        ),
                      ),
                      Text(
                        '- lib/app (Pasta onde contém o código da aplicação)',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.primaryColor,
                        ),
                      ),
                      Text(
                        '- lib/app/core (Contém definições e utilitários centrais do projeto, que podem ser usados em qualquer parte da aplicação. Exemplos: modelos de dados (models), constantes, ui, exceptions, widget, tema do app, etc.)',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.primaryColor,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      Text(
                        '- lib/app/modules (Agrupa funcionalidades ou telas por domínio ou recurso. Cada módulo representa uma área da aplicação (produto e usuário).)',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.primaryColor,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      Text(
                        '- lib/app/repositories (Pasta que contém as classes de acesso a dados de cada módulo da aplicação. O repositório implementa métodos para buscar, salvar, atualizar e remover dados, servindo de ponte entre a camada de dados e os services/controllers.)',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.primaryColor,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      Text(
                        '- lib/app/services (Contém a regra de negócio da aplicação e usa os repositórios para acessar dados e implementam as regras de negócio e validações. Os controllers acessam os services para manipular dados.)',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.primaryColor,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      Text(
                        '- android/, ios/, web/ e windows/ (Contém a compilação de cada plataforma.)',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.primaryColor,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      Text(
                        '- assets/ (Contém as imagens e icónes da aplicação.)',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.primaryColor,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      Text(
                        '- pubspec.yaml (Gerenciamento de dependências da aplicação.)',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.primaryColor,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      Text(
                        '- test/ (Contém todos os testes da aplicação, foi criado alguns testes para validar o conhecimento em testes.)',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.primaryColor,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Versão $_version',
                  style: TextStyle(fontSize: 14, color: context.primaryColor),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Desenvolvido por Anderson Gonçalves',
                    style: TextStyle(fontSize: 14, color: context.primaryColor),
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
