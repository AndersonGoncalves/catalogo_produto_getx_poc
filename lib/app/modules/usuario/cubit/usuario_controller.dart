import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catalogo_produto_poc/app/core/exceptions/auth_exception.dart';
import 'package:catalogo_produto_poc/app/services/usuario/usuario_service_impl.dart';
import 'package:catalogo_produto_poc/app/modules/usuario/cubit/usuario_state.dart';

class UsuarioController extends Cubit<UsuarioState> {
  final UsuarioServiceImpl _usuarioService;

  UsuarioController({required UsuarioServiceImpl usuarioService})
    : _usuarioService = usuarioService,
      super(UsuarioState());

  Future<void> register(String name, String email, String password) async {
    emit(state.copyWith(isLoading: true, error: null, success: false));
    try {
      final user = await _usuarioService.register(name, email, password);
      if (user != null) {
        emit(state.copyWith(isLoading: false, success: true));
      } else {
        emit(
          state.copyWith(isLoading: false, error: 'Erro ao registrar usuário'),
        );
      }
    } on AuthException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Erro ao registrar usuário: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, error: null, success: false));
    try {
      final user = await _usuarioService.login(email, password);
      if (user != null) {
        emit(state.copyWith(isLoading: false, success: true));
      } else {
        emit(
          state.copyWith(isLoading: false, error: 'Usuário ou senha inválida'),
        );
      }
    } on AuthException catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message));
    }
  }

  Future<void> googleLogin() async {
    emit(state.copyWith(isLoading: true, error: null, success: false));
    try {
      final user = await _usuarioService.googleLogin();
      if (user != null) {
        emit(state.copyWith(isLoading: false, success: true));
      } else {
        _usuarioService.logout();
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Erro ao realizar login com google',
          ),
        );
      }
    } on AuthException catch (e) {
      _usuarioService.logout();
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Erro ao realizar login com google: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> loginAnonimo() async {
    emit(state.copyWith(isLoading: true, error: null, success: false));
    try {
      await _usuarioService.loginAnonimo();
      emit(state.copyWith(isLoading: false, success: true));
    } on AuthException catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message));
    }
  }

  Future<void> converterContaAnonimaEmPermanente(
    String email,
    String password,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, success: false));
    try {
      final user = await _usuarioService.converterContaAnonimaEmPermanente(
        email,
        password,
      );
      if (user != null) {
        emit(state.copyWith(isLoading: false, success: true));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            error: 'Não foi possível converter o usuário anônimo',
          ),
        );
      }
    } on AuthException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Não foi possível converter o usuário anônimo: ${e.message}',
        ),
      );
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(isLoading: true, error: null, success: false));
    try {
      await _usuarioService.logout();
      emit(state.copyWith(isLoading: false, success: true));
    } on AuthException catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message));
    }
  }

  Future<void> esqueceuSenha(String email) async {
    emit(state.copyWith(isLoading: true, error: null, success: false));
    try {
      await _usuarioService.esqueceuSenha(email);
      emit(state.copyWith(isLoading: false, success: true));
    } on AuthException catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Erro ao resetar senha: ${e.toString()}',
        ),
      );
    }
  }
}
