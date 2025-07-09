import 'usuario_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:catalogo_produto_poc/app/repositories/usuario/usuario_repository.dart';

class UsuarioServiceImpl implements UsuarioService {
  final UsuarioRepository _usuarioRepository;

  UsuarioServiceImpl({required UsuarioRepository usuarioRepository})
    : _usuarioRepository = usuarioRepository;

  @override
  User get user => _usuarioRepository.user;

  @override
  Stream<User?> get authState => _usuarioRepository.authState;

  @override
  Future<User?> register(String name, String email, String password) =>
      _usuarioRepository.register(name, email, password);

  @override
  Future<User?> login(String email, String password) {
    return _usuarioRepository.login(email, password);
  }

  @override
  Future<User?> googleLogin() {
    return _usuarioRepository.googleLogin();
  }

  @override
  Future<User?> loginAnonimo() => _usuarioRepository.loginAnonimo();

  @override
  Future<User?> converterContaAnonimaEmPermanente(
    String email,
    String password,
  ) => _usuarioRepository.converterContaAnonimaEmPermanente(email, password);

  @override
  Future<void> logout() {
    return _usuarioRepository.logout();
  }

  @override
  Future<void> esqueceuSenha(String email) {
    return _usuarioRepository.esqueceuSenha(email);
  }
}
