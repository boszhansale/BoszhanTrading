import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:boszhan_trading/utils/styles/styles.dart';
import 'package:boszhan_trading/widgets/background__image_widget.dart';
import 'package:boszhan_trading/widgets/custom_full_width_button.dart';
import 'package:boszhan_trading/widgets/show_custom_snackbar.dart';
import 'package:boszhan_trading/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final repository = AuthRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            setBackgroundImage(),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  decoration: ProjectStyles.containerDecoration,
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('../assets/images/logo.png'),
                        const SizedBox(height: 10),
                        const Center(
                          child: Text('Авторизация',
                              style: ProjectStyles.textStyle_22Bold),
                        ),
                        const Text('Логин',
                            style: ProjectStyles.textStyle_14Bold),
                        customTextFormField(
                          () {},
                          controller: loginController,
                          hintText: 'Логин',
                        ),
                        const Text('Пароль',
                            style: ProjectStyles.textStyle_14Bold),
                        customTextFormField(() {},
                            controller: passwordController, hintText: 'Пароль'),
                        customFullWidthButton(
                          () {
                            login();
                          },
                          title: 'Войти',
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login() async {
    try {
      final loginResponse =
          await repository.login(loginController.text, passwordController.text);
      await repository.setUserId(loginResponse.user.id);
      await repository.setUserToken(loginResponse.accessToken);
      await repository.setUserToCache(loginResponse.user);

      if (mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', ModalRoute.withName('/'));
      }
    } catch (e) {
      showCustomSnackBar(context, e.toString());
      print(e);
    }
  }
}
