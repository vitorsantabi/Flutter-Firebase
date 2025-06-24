import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserCredential?> cadUser({
    required String email,
    required String senha,
    required String nome,
  }) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      // Atualiza o displayName do usuário após cadastro
      await userCredential.user?.updateDisplayName(nome);
      await userCredential.user?.reload();
      return auth.currentUser != null ? userCredential : null;
    } on FirebaseAuthException {
      // Trate erros específicos do Firebase aqui, se desejar
      rethrow;
    }
  }

  Future<UserCredential?> loginUser({
    required String email,
    required String senha,
  }) async {
    try {
      return await auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
    } on FirebaseAuthException {
      // Trate erros específicos do Firebase aqui, se desejar
      rethrow;
    }
  }

  Future<UserCredential?> loginUserAlternative({
    required String email,
    required String senha,
  }) async {
    try {
      return await auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
    } catch (e) {
      rethrow;
    }
  }
  Logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      // Trate erros de logout, se necessário
      rethrow;
    }
  }
}
