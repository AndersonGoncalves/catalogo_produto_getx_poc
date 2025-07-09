import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:catalogo_produto_poc/app/core/exceptions/auth_exception.dart';
import 'package:catalogo_produto_poc/app/repositories/usuario/usuario_repository.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final FirebaseAuth _firebaseAuth;

  UsuarioRepositoryImpl({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  @override
  User get user => _firebaseAuth.currentUser!;

  @override
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  @override
  Future<User?> register(String name, String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (name.isNotEmpty) {
        await userCredential.user?.updateDisplayName(name);
      }
      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        final loginTypes = await _firebaseAuth.fetchSignInMethodsForEmail(
          email,
        );
        if (loginTypes.contains('password')) {
          throw AuthException(
            message: 'Email já utilizado, por favor escolha outro email',
          );
        } else {
          throw AuthException(
            message:
                'Você se cadastrou pelo google, por favor utilize ele para entrar',
          );
        }
      } else {
        throw AuthException(message: e.message ?? 'Erro ao registrar usuário');
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on PlatformException catch (e) {
      throw AuthException(message: e.message ?? 'Erro ao realizar login');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw AuthException(message: e.message ?? 'Login ou senha inválidos');
      }
      throw AuthException(message: e.message ?? 'Erro ao realizar login');
    }
  }

  @override
  Future<User?> googleLogin() async {
    List<String>? loginMethods;
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        loginMethods = await _firebaseAuth.fetchSignInMethodsForEmail(
          googleUser.email,
        );

        if (loginMethods.contains('password')) {
          throw AuthException(
            message:
                'Você utilizou o email para cadastro, caso tenha esquecido sua senha por favor clique no link esqueci a senha',
          );
        } else {
          final googleAuth = await googleUser.authentication;
          final firebaseCredential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          var userCredential = await _firebaseAuth.signInWithCredential(
            firebaseCredential,
          );
          return userCredential.user;
        }
      } else {
        return Future.value(null);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw AuthException(
          message:
              '''
          Login inválido, você se registrou todoList com os seguintes provedores: 
          ${loginMethods?.join(',')}
        ''',
        );
      } else {
        throw AuthException(message: 'Erro ao realizar login');
      }
    }
  }

  @override
  Future<User?> loginAnonimo() async {
    try {
      var userCredential = await _firebaseAuth.signInAnonymously();
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: 'Erro ao realizar login: $e');
    }
  }

  @override
  Future<User?> converterContaAnonimaEmPermanente(
    String email,
    String password,
  ) async {
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    try {
      var userCredential = await _firebaseAuth.currentUser?.linkWithCredential(
        credential,
      );
      return userCredential!.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: 'Erro ao realizar login: $e');
    }
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    _firebaseAuth.signOut();
  }

  @override
  Future<void> esqueceuSenha(String email) async {
    try {
      final loginMethods = await _firebaseAuth.fetchSignInMethodsForEmail(
        email,
      );
      if (loginMethods.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginMethods.contains('google')) {
        throw AuthException(
          message:
              'Cadastro realizado com o google não pode ser resetado a senha',
        );
      } else {
        throw AuthException(message: 'Email não cadastrado');
      }
    } on PlatformException catch (e) {
      throw AuthException(message: 'erro ao resetar senha: $e');
    }
  }
}
