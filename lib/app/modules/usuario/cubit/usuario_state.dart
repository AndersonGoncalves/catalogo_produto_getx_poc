class UsuarioState {
  String? error;
  bool success = false;
  bool isLoading = false;

  UsuarioState({this.error, this.success = false, this.isLoading = false});

  UsuarioState copyWith({String? error, bool? success, bool? isLoading}) {
    return UsuarioState(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
    );
  }
}
