import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:catalogo_produto_poc/app/core/ui/messages.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_loading_page.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_text_form_field.dart';
import 'package:catalogo_produto_poc/app/core/widget/widget_text_button.dart';
import 'package:catalogo_produto_poc/app/modules/usuario/cubit/usuario_controller.dart';
import 'package:catalogo_produto_poc/app/modules/usuario/cubit/usuario_state.dart';

enum AuthMode { signup, login }

class UsuarioFormPage extends StatefulWidget {
  final bool usuarioAnonimo;

  const UsuarioFormPage({this.usuarioAnonimo = false, super.key});

  @override
  State<UsuarioFormPage> createState() => UsuariohFormPageState();
}

class UsuariohFormPageState extends State<UsuarioFormPage>
    with SingleTickerProviderStateMixin {
  late AuthMode? _authMode;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final Map<String, String> _formData = {'email': '', 'password': ''};

  AnimationController? _controller;
  bool get _isLogin => _authMode == AuthMode.login;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin) {
        _authMode = AuthMode.signup;
        _controller?.forward();
      } else {
        _authMode = AuthMode.login;
        _controller?.reverse();
      }
    });
  }

  Future<void> _submit() async {
    final formValid = _formKey.currentState?.validate() ?? false;

    if (formValid) {
      _formKey.currentState?.save();
      UsuarioController usuarioController = context.read<UsuarioController>();

      if (_isLogin) {
        await usuarioController.login(
          _formData['email']!,
          _formData['password']!,
        );
      } else {
        if (widget.usuarioAnonimo) {
          await usuarioController.converterContaAnonimaEmPermanente(
            _formData['email']!,
            _formData['password']!,
          );
        } else {
          await usuarioController.register(
            _formData['name']!,
            _formData['email']!,
            _formData['password']!,
          );
        }
      }
    }
  }

  Future<void> _loginAnonimo() async {
    if (widget.usuarioAnonimo) {
      Navigator.of(context).pop();
    } else {
      UsuarioController usuarioController = context.read<UsuarioController>();
      await usuarioController.loginAnonimo();
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.usuarioAnonimo) {
      _authMode = AuthMode.signup;
    } else {
      _authMode = AuthMode.login;
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsuarioController, UsuarioState>(
      listener: (context, state) {
        if (state.success) {
          Navigator.of(context).pop();
        } else if (state.error != null && state.error!.isNotEmpty) {
          Messages.of(context).showError(state.error!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: state.isLoading
              ? WidgetLoadingPage(
                  label: 'Carregando...',
                  labelColor: Colors.white,
                )
              : SafeArea(
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: SingleChildScrollView(
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Card(
                                    color: Theme.of(context).canvasColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Form(
                                      key: _formKey,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 110,
                                              width: 110,
                                              child: Image.asset(
                                                'assets/icon/icon-adaptive.png',
                                              ),
                                            ),
                                            FittedBox(
                                              child: Text(
                                                'PoC',
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 5,
                                                bottom: 5,
                                                left: 10,
                                                right: 10,
                                              ),
                                              child: Text(
                                                _isLogin
                                                    ? 'Informe um email e uma senha de 6 dígitos e tenha acesso ao App'
                                                    : 'Informe um email e uma senha de 6 dígitos e registre-se no App',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            _isLogin
                                                ? const SizedBox()
                                                : WidgetTextFormField(
                                                    labelText: 'Nome',
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    prefixIcon: const Icon(
                                                      Icons
                                                          .account_circle_outlined,
                                                    ),
                                                    isDense: true,
                                                    border: true,
                                                    onSaved: (value) =>
                                                        _formData['name'] =
                                                            value ?? '',
                                                  ),
                                            WidgetTextFormField(
                                              key: const Key('email_key'),
                                              labelText: 'Email',
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              textInputAction:
                                                  TextInputAction.next,
                                              prefixIcon: const Icon(
                                                Icons.email_outlined,
                                              ),
                                              isDense: true,
                                              border: true,
                                              controller: _emailController,
                                              validator: (value) {
                                                final email = value ?? '';
                                                if (email.isEmpty ||
                                                    !email.contains('@')) {
                                                  return 'Informe um email válido';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) =>
                                                  _formData['email'] =
                                                      value ?? '',
                                            ),
                                            WidgetTextFormField(
                                              labelText: 'Senha',
                                              prefixIcon: const Icon(
                                                Icons.lock_outline,
                                              ),
                                              isDense: true,
                                              border: true,
                                              keyboardType: TextInputType.text,
                                              textInputAction:
                                                  TextInputAction.next,
                                              controller: _passwordController,
                                              obscureText: true,
                                              validator: (value) {
                                                final password = value ?? '';
                                                if (password.isEmpty ||
                                                    password.length < 5) {
                                                  return 'Informe uma senha válida';
                                                }
                                                return null;
                                              },
                                              onSaved: (password) =>
                                                  _formData['password'] =
                                                      password ?? '',
                                            ),
                                            _isLogin
                                                ? const SizedBox()
                                                : WidgetTextFormField(
                                                    labelText:
                                                        'Confirmar Senha',
                                                    prefixIcon: const Icon(
                                                      Icons.lock_outline,
                                                    ),
                                                    isDense: true,
                                                    border: true,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    obscureText: true,
                                                    validator: _isLogin
                                                        ? null
                                                        : (value) {
                                                            final password =
                                                                value ?? '';
                                                            if (password !=
                                                                _passwordController
                                                                    .text) {
                                                              return 'Senhas informadas não conferem';
                                                            }
                                                            return null;
                                                          },
                                                  ),
                                            _isLogin
                                                ? const SizedBox()
                                                : Column(
                                                    children: [
                                                      Text(
                                                        'Ao usar o app, você concorda com nossos',
                                                        style: const TextStyle(
                                                          fontSize: 9,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {},
                                                        child: Text(
                                                          'Termos de Uso & Política de Privacidade',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .primary,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            const SizedBox(height: 20),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 6,
                                              ),
                                              child: ElevatedButton(
                                                key: const Key(
                                                  'usuario_form_entrar_key',
                                                ),
                                                onPressed: _submit,
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
                                                        ),
                                                  ),
                                                  minimumSize: Size(
                                                    double.infinity,
                                                    48,
                                                  ),
                                                  elevation: 0,
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                                child: Text(
                                                  _authMode == AuthMode.login
                                                      ? 'ENTRAR'
                                                      : 'REGISTRAR',
                                                ),
                                              ),
                                            ),
                                            _authMode == AuthMode.login
                                                ? Row(
                                                    children: [
                                                      Expanded(
                                                        child: SignInButton(
                                                          Buttons.Google,
                                                          text:
                                                              'Login com Google',
                                                          elevation: 1,
                                                          padding:
                                                              const EdgeInsets.all(
                                                                5,
                                                              ),
                                                          shape: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  5,
                                                                ),
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                          onPressed: () {
                                                            context
                                                                .read<
                                                                  UsuarioController
                                                                >()
                                                                .googleLogin();
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : SizedBox.shrink(),
                                            _isLogin
                                                ? WidgetTextButton(
                                                    'Esqueceu a senha?',
                                                    onPressed: () async {
                                                      await context
                                                          .read<
                                                            UsuarioController
                                                          >()
                                                          .esqueceuSenha(
                                                            _emailController
                                                                .text,
                                                          );
                                                      Messages.of(context).info(
                                                        'Recuperação de senha enviada para email informado',
                                                      );
                                                    },
                                                  )
                                                : SizedBox.shrink(),

                                            widget.usuarioAnonimo
                                                ? const SizedBox()
                                                : WidgetTextButton(
                                                    _isLogin
                                                        ? 'DESEJA REGISTRAR?'
                                                        : 'JÁ POSSUI CONTA?',
                                                    onPressed: _switchAuthMode,
                                                  ),
                                            WidgetTextButton(
                                              'NÃO QUERO ME REGISTRAR!',
                                              foregroundColor: Colors.red,
                                              onPressed: _loginAnonimo,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
