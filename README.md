# Catálogo de Produtos

Aplicativo de cadastro e gerenciamento de produtos com possibilidadede inclusão no carrinho de compras, desenvolvido por Anderson Gonçalves como uma prova de conceito utilizando Flutter, Dart e Firebase.

## 📚 Descrição

Este app permite que usuários cadastrem, visualizem e gerenciem produtos. É possível adicionar até três fotos para cada produto e o acesso do usuário ao app pode ser feito de forma anônima ou autenticando-se via e-mail. O usuário também pode incluir os produtos no carrinho e finalizar uma compra. Todos os dados de produtos e autenticação são gerenciados via Firebase.
Esse app utiliza o GetX para gerenciar rotas, gerenciar estados e gerenciar dependências.

## 🚀 Tecnologias Utilizadas

- *Frontend:*  
  - [Flutter](https://flutter.dev/)  
  - [Dart](https://dart.dev/)
  - [GetX](https://pub.dev/packages/get)
- *Backend:*  
  - [Realtime Database](https://firebase.google.com/products/realtime-database) (armazenamento dos produtos)
  - [Firebase Authentication](https://firebase.google.com/products/auth) (autenticação anônima e por e-mail)  

## ⚙️ Funcionalidades

- Listagem de produtos cadastrados.
- Inclusão do produto no carrinho de compras.
- Cadastro/edição de produto com os campos:
  - Nome
  - Descrição
  - Preço de Custo
  - Preço de Venda
  - Quantidade em Estoque
  - Codigo de Barras
  - Marca  
  - Fotos do produto
- Autenticação de usuário:
  - Login anônimo
  - Login com e-mail e senha
  - Login com google
  - Recuperação de senha
- Upload e exibição de fotos dos produtos.
- Integração em tempo real com Firebase.

## 🖼️ Exemplos de Tela

![register](https://github.com/user-attachments/assets/c2501862-df6d-4ffe-9122-506f5d408e95)

![produto_grid](https://github.com/user-attachments/assets/942c5b1b-b02f-4575-b37f-c8155ad6da30)

![produto_list](https://github.com/user-attachments/assets/aacf73e7-e9b7-4d48-8bf8-cc930ef624cb)

![produto_form](https://github.com/user-attachments/assets/72e5c471-b202-4e48-ac13-d594e0d8be53)

![carrinho_page](https://github.com/user-attachments/assets/611c86e8-f3f7-46e8-8360-9b7a8bdb520d)

![produto_calculadora_preco](https://github.com/user-attachments/assets/e5cb8677-6edc-4e13-aab6-d97cab11db42)

![sobre](https://github.com/user-attachments/assets/dc36c9e2-6aa7-443e-9966-987dfa41e69e)

## 📦 Estrutura do Projeto

- lib/ (Código principal do Flutter)
- lib/app (Pasta onde contém o código da aplicação)
- lib/app/core (Contém definições e utilitários centrais do projeto, que podem ser usados em qualquer parte da aplicação)
Exemplos: modelos de dados (models), constantes, ui, exceptions, widget, tema do app, etc.
- lib/app/modules (Agrupa funcionalidades ou telas por domínio ou recurso.
Cada módulo representa uma área da aplicação, usuário, produto e carrinho)
- lib/app/repositories (Pasta que contém as classes de acesso a dados de cada módulo da aplicação. O repositório implementa métodos para buscar, salvar, atualizar e remover dados, servindo de ponte entre a camada de dados e os services/controllers)
- lib/app/services (Contém a regra de negócio da aplicação e usa os repositórios para acessar dados e implementam as regras de negócio e validações. Os controllers acessam os services para manipular dados)
- android/, ios/, web/ e windows/ (Contém a compilação de cada plataforma)
- assets/ (Contém as imagens e icónes da aplicação)
- pubspec.yaml (Gerenciamento de dependências)
- test/ (Contém todos os testes da aplicação, foram criados alguns testes para validar o conhecimento em testes)

## 🛠️ Instalação e Execução

1. *Clone este repositório*
   bash
   git clone https://github.com/AndersonGoncalves/catalogo_produto_getx_poc.git
   cd catalogo_produto_getx_poc   

2. *Instale as dependências*
   bash
   flutter pub get   

3. *Configure o Firebase*
   - Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
   - Baixe o arquivo google-services.json (Android) e/ou GoogleService-Info.plist (iOS) e coloque nas pastas correspondentes.
   - Habilite Firestore, Authentication (anônimo e e-mail/senha) e Storage.

4. *Execute o app*
   bash
   flutter run   

> Certifique-se de ter o Flutter instalado e um emulador/dispositivo conectado.
