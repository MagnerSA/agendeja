import 'package:agendeja/routes/routes.dart';
import 'package:agendeja/services/user.service.dart';
import 'package:agendeja/style/sizes.dart';
import 'package:agendeja/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'widgets/input.dart';
import 'widgets/panel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserService userService = UserService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool hasLoginFailed = false;
  bool isLoadingLogin = false;

  bool isRegister = false;

  bool showPassword = false;

  @override
  initState() {
    initPage();
    super.initState();
  }

  initPage() async {
    bool isUserLogged = await userService.isUserLogged();

    if (isUserLogged) {
      navigateToHome();
    }
  }

  navigateToHome() {
    Navigator.popAndPushNamed(context, routeHome);
  }

  login() async {
    setState(() {
      isLoadingLogin = true;
    });
    FocusScope.of(context).unfocus();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    bool success = false;

    if (email != "" && password != "") {
      await Future.delayed(const Duration(milliseconds: 1000), () async {
        success = await userService.login(email, password);
      });
    }

    if (success) {
      navigateToHome();
    } else {
      setState(() {
        hasLoginFailed = true;
      });

      Future.delayed(const Duration(milliseconds: 1000), () async {
        setState(() {
          hasLoginFailed = false;
        });
      });
    }

    setState(() {
      isLoadingLogin = false;
    });
  }

  register() async {
    setState(() {
      isLoadingLogin = true;
    });
    FocusScope.of(context).unfocus();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();

    bool success = false;

    if (email != "" && password != "" && name != "") {
      await Future.delayed(const Duration(milliseconds: 1000), () async {
        success = await userService.register(email, password, name);
      });
    }

    if (success) {
      _setIsRegister();
      _passwordController.clear();
      _nameController.clear();
    } else {
      setState(() {
        hasLoginFailed = true;
      });

      Future.delayed(const Duration(milliseconds: 1000), () async {
        setState(() {
          hasLoginFailed = false;
        });
      });
    }

    setState(() {
      isLoadingLogin = false;
    });
  }

  _setIsRegister() {
    setState(() {
      isRegister = !isRegister;
    });
    if (isRegister) {
      setState(() {
        _nameController.clear();
        _passwordController.clear();
      });
    }
  }

  _loginButton() {
    return Panel(
      height: 50,
      onTap: isRegister ? register : login,
      color: hasLoginFailed ? redColor : secondaryColor,
      child: Center(
        child: Text(
          isRegister ? "Cadastrar" : "Login",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _registerButton() {
    return Panel(
      height: 50,
      onTap: _setIsRegister,
      color: hasLoginFailed ? redColor : greyColor,
      child: Center(
        child: Text(
          isRegister ? "Cancelar" : "Cadastrar",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _widgetLogo() {
    return SizedBox(
      height: getSizeHeight(context) * 8,
      width: w(context, isMobile(context) ? 100 : 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/images/full-logo.png'),
            width: 300, // Largura desejada da imagem
            // height: 200, // Altura desejada da imagem
            fit: BoxFit.contain, // Ajuste da imagem dentro do widget Image
          ),
          const Text(
            "AgendeJa",
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
          ),
          sizedBox(context),
          const Text(
            "by Marcelo Andrade",
            style: TextStyle(
              color: greyColor,
              fontWeight: FontWeight.w100,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  _widgetNameColumn() {
    return isRegister
        ? [
            const Text("Nome"),
            smallSizedBox(context),
            Input(
              error: hasLoginFailed,
              height: getSizeHeight(context),
              hintText: "Nome",
              controller: _nameController,
            ),
            SizedBox(height: getSizeSpace(context) * 1.5),
          ]
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: isNotMobile(context),
                child: Expanded(
                  child: Center(
                    child: Panel(
                      child: Padding(
                        padding: EdgeInsets.all(getSizeHeight(context)),
                        child: _widgetLogo(),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Panel(
                  child: Padding(
                    padding: EdgeInsets.all(w(context, 7.5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: isMobile(context),
                          child: _widgetLogo(),
                        ),
                        SizedBox(height: getSizeHeight(context)),
                        Visibility(
                          visible: isNotMobile(context),
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: getSizeHeight(context),
                            ),
                            child: Text(
                              "Bem vindo ao AgendeJa",
                              style: TextStyle(
                                color:
                                    hasLoginFailed ? Colors.red : primaryColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        ..._widgetNameColumn(),
                        const Text("E-mail"),
                        smallSizedBox(context),
                        Input(
                          error: hasLoginFailed,
                          height: getSizeHeight(context),
                          hintText: "E-mail",
                          controller: _emailController,
                        ),
                        SizedBox(height: getSizeSpace(context) * 1.5),
                        const Text("Senha"),
                        smallSizedBox(context),
                        Input(
                          onSubmitted: (_) {
                            login();
                          },
                          error: hasLoginFailed,
                          height: getSizeHeight(context),
                          hintText: "Senha",
                          obscureText: !showPassword,
                          controller: _passwordController,
                        ),
                        smallSizedBox(context),
                        Panel(
                          hasShadow: false,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "${showPassword ? "Ocultar" : "Exibir"} senha",
                                textAlign: TextAlign.end,
                                style: TextStyle(color: primaryColor),
                              ),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                        SizedBox(height: getSizeHeight(context)),
                        _loginButton(),
                        SizedBox(height: getSizeSpace(context)),
                        _registerButton(),
                        SizedBox(height: getSizeHeight(context)),
                        Visibility(
                          visible: isLoadingLogin,
                          child: const SpinKitThreeBounce(
                            color: primaryColor,
                            size: 20,
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
      ),
    );
  }
}
