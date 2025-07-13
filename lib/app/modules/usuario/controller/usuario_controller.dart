import 'package:get/get.dart';
import 'package:catalogo_produto_poc/app/core/ui/messages.dart';
import 'package:catalogo_produto_poc/app/core/exceptions/auth_exception.dart';
import 'package:catalogo_produto_poc/app/services/usuario/usuario_service_impl.dart';

class UsuarioController extends GetxController {
  final UsuarioServiceImpl _usuarioService;

  UsuarioController({required UsuarioServiceImpl usuarioService})
    : _usuarioService = usuarioService;

  // Observables reactivos
  final RxString _error = RxString('');
  final RxBool _success = false.obs;
  final RxBool _isLoading = false.obs;

  // Getters para acessar os valores reativos
  String get error => _error.value;
  bool get success => _success.value;
  bool get isLoading => _isLoading.value;

  // Getters para observables (para uso em workers externos)
  RxString get errorObservable => _error;
  RxBool get successObservable => _success;
  RxBool get isLoadingObservable => _isLoading;

  void _setLoading(bool loading) {
    _isLoading.value = loading;
    if (loading) {
      _error.value = '';
      _success.value = false;
    }
  }

  void _setSuccess() {
    _success.value = true;
    _isLoading.value = false;
    _error.value = '';
  }

  void _setError(String errorMessage) {
    _error.value = errorMessage;
    _isLoading.value = false;
    _success.value = false;
  }

  Future<void> register(String name, String email, String password) async {
    _setLoading(true);

    try {
      final user = await _usuarioService.register(name, email, password);
      if (user != null) {
        _setSuccess();
      } else {
        _setError('Erro ao registrar usuário');
      }
    } on AuthException catch (e) {
      _setError('Erro ao registrar usuário: ${e.toString()}');
    } catch (e) {
      _setError('Erro inesperado ao registrar usuário: ${e.toString()}');
    }
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);

    try {
      final user = await _usuarioService.login(email, password);
      if (user != null) {
        _setSuccess();
      } else {
        _setError('Usuário ou senha inválida');
      }
    } on AuthException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Erro inesperado ao fazer login: ${e.toString()}');
    }
  }

  Future<void> googleLogin() async {
    _setLoading(true);

    try {
      final user = await _usuarioService.googleLogin();
      if (user != null) {
        _setSuccess();
      } else {
        await _usuarioService.logout();
        _setError('Erro ao realizar login com google');
      }
    } on AuthException catch (e) {
      await _usuarioService.logout();
      _setError('Erro ao realizar login com google: ${e.toString()}');
    } catch (e) {
      await _usuarioService.logout();
      _setError('Erro inesperado no login com Google: ${e.toString()}');
    }
  }

  Future<void> loginAnonimo() async {
    _setLoading(true);

    try {
      await _usuarioService.loginAnonimo();
      _setSuccess();
    } on AuthException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Erro inesperado no login anônimo: ${e.toString()}');
    }
  }

  Future<void> converterContaAnonimaEmPermanente(
    String email,
    String password,
  ) async {
    _setLoading(true);

    try {
      final user = await _usuarioService.converterContaAnonimaEmPermanente(
        email,
        password,
      );
      if (user != null) {
        _setSuccess();
      } else {
        _setError('Não foi possível converter o usuário anônimo');
      }
    } on AuthException catch (e) {
      _setError('Não foi possível converter o usuário anônimo: ${e.message}');
    } catch (e) {
      _setError('Erro inesperado ao converter conta: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    try {
      await _usuarioService.logout();
      _setSuccess();
    } on AuthException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Erro inesperado ao fazer logout: ${e.toString()}');
    }
  }

  Future<void> esqueceuSenha(String email) async {
    _setLoading(true);

    try {
      await _usuarioService.esqueceuSenha(email);
      _setSuccess();
    } on AuthException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError('Erro ao resetar senha: ${e.toString()}');
    }
  }

  // Workers para side effects
  void _setupWorkers() {
    // Worker para monitorar mudanças no sucesso
    ever(_success, (bool success) {
      if (success) {
        // Pode ser usado para navegação ou outras ações
        // quando uma operação é bem-sucedida
      }
    });

    // Worker para monitorar erros
    ever(_error, (String error) {
      if (error.isNotEmpty) {
        // Pode ser usado para mostrar snackbars de erro
        Messages.showError(error);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    _setupWorkers();
  }

  // Métodos para limpar o estado
  void clearError() {
    _error.value = '';
  }

  void clearSuccess() {
    _success.value = false;
  }

  void clearAll() {
    _error.value = '';
    _success.value = false;
    _isLoading.value = false;
  }
}
