import 'package:app_login/auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool entrar = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmaSenhaController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final AuthService auth = AuthService();
  bool loading = false;
  String? feedbackMsg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Colors.blue[700],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    entrar ? 'Bem-vindo!' : 'Crie sua conta',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (!entrar)
                    Column(
                      children: [
                        TextFormField(
                          controller: nomeController,
                          decoration: InputDecoration(
                            hintText: 'Nome',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          validator: (value) {
                            if (!entrar && (value == null || value.isEmpty)) {
                              return 'Por favor, preencha seu nome';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, preencha este campo';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Por favor, insira um e-mail válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: senhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Senha',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, preencha este campo';
                      }
                      if (value.length < 6) {
                        return 'A senha deve ter pelo menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  if (!entrar)
                    Column(
                      children: [
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: confirmaSenhaController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Confirme a senha',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          validator: (value) {
                            if (!entrar && (value == null || value.isEmpty)) {
                              return 'Por favor, confirme sua senha';
                            }
                            if (!entrar && value != senhaController.text) {
                              return 'As senhas não coincidem';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  if (loading) const CircularProgressIndicator(),
                  if (feedbackMsg != null) ...[
                    Text(
                      feedbackMsg!,
                      style: TextStyle(
                        color: feedbackMsg!.contains('sucesso') ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: loading ? null : () => botaoEntrar(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: Text(entrar ? 'Entrar' : 'Cadastrar'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: loading
                        ? null
                        : () {
                            setState(() {
                              feedbackMsg = null;
                              entrar = !entrar;
                            });
                          },
                    child: Text(
                      entrar
                          ? 'Não tem conta? Cadastre-se'
                          : 'Já tem conta? Entrar',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> botaoEntrar() async {
    setState(() {
      feedbackMsg = null;
    });
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      String email = emailController.text.trim();
      String senha = senhaController.text.trim();
      String nome = nomeController.text.trim();
      try {
        if (entrar) {
          // Login
          await auth.loginUser(email: email, senha: senha);
          setState(() {
            feedbackMsg = 'Login realizado com sucesso!';
          });
        } else {
          // Cadastro
          await auth.cadUser(email: email, senha: senha, nome: nome);
          setState(() {
            feedbackMsg = 'Cadastro realizado com sucesso!';
            entrar = true;
          });
        }
      } catch (e) {
        setState(() {
          feedbackMsg = 'Erro: ${e.toString()}';
        });
      } finally {
        setState(() {
          loading = false;
        });
      }
    } else {
      setState(() {
        feedbackMsg = 'Formulário inválido';
      });
    }
  }
}
