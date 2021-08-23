import 'package:flutter/material.dart';
import 'package:memory/model/user.dart';
import 'package:memory/utils/cache_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  UserRepository _userRepository = UserRepository();

  // 用户输入的账号密码信息
  String _username = '';
  String _account = '';
  String _password = '';
  String _confirmpw = '';

  bool _enable = false;
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  final userNameEditingController = TextEditingController();
  final accountEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmEditingController = TextEditingController();

  Future<SharedPreferences> _pres = SharedPreferences.getInstance();

  void _showDialog(String title, String content, bool isToLogin) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            )),
            content: Text(content),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (isToLogin) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('确定')),
            ],
          );
        });
  }

  // 注册事件
  void _clickEvent() async {
    // 校验参数

    // 校验成功，上传数据
    _userRepository
        .signup(this._username, this._account, this._password, this._confirmpw)
        .then((res) async {
      if (res[0] == 'success') {
        final pres = await _pres;

        // 注册成功后,将账号和密码保存在缓存中
        pres.setString(Constants.accountKey, accountEditingController.text);
        pres.setString(Constants.passwordKey, passwordEditingController.text);

        _showDialog('注册成功', res[1], true);
      } else {
        _showDialog('注册失败', res[1], false);
      }
    });
  }

  // 检测按钮是否可用,验证用户输入的信息合法后,按钮可用
  void _checkRegistratState() {
    setState(() {
      if (this._username != "" &&
          this._account != "" &&
          this._password != "" &&
          this._confirmpw != "")
        this._enable = true;
      else
        this._enable = false;
    });
  }

  // 欢迎文字
  Widget _textWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "注册",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.0, top: 8.0),
            child: Container(
              height: 3.0,
              width: 40.0,
              decoration: new BoxDecoration(
                //背景
                color: Colors.black,
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                //设置四周边框
                border: new Border.all(width: 1, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 账号输入框
  Widget _accountTextField(
      TextEditingController controller, String hintText, int nameOrAcc) {
    return Padding(
      padding: EdgeInsets.only(top: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: IconButton(
            icon: Image.asset("assets/icons/yonghu.png",
                height: 18.0, width: 18.0),
            onPressed: () {},
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: Color(0xFF000000),
            width: 1.0,
          )),
        ),
        onChanged: (value) {
          if (nameOrAcc == 0) {
            this._username = value;
          } else if (nameOrAcc == 1) {
            this._account = value;
          }
          _checkRegistratState();
        },
      ),
    );
  }

  // 密码,验证密码输入框
  Widget _passwordTextField(
      TextEditingController controller, String hintText, int pwOrCpw) {
    return Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Color(0xFF000000),
              width: 1.0,
            )),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  if (pwOrCpw == 0) {
                    this._obscureText1 = !this._obscureText1;
                  } else if (pwOrCpw == 1) {
                    this._obscureText2 = !this._obscureText2;
                  }
                });
              },
              icon: pwOrCpw == 0
                  ? Image.asset(
                      this._obscureText1
                          ? "assets/icons/closeEye.png"
                          : "assets/icons/openEye.png",
                      width: 20.0,
                      height: 20.0,
                    )
                  : Image.asset(
                      this._obscureText2
                          ? "assets/icons/closeEye.png"
                          : "assets/icons/openEye.png",
                      width: 20.0,
                      height: 20.0,
                    ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            )),
        obscureText: pwOrCpw == 0 ? this._obscureText1 : this._obscureText2,
        onChanged: (value) {
          if (pwOrCpw == 0) {
            this._password = value;
          } else if (pwOrCpw == 1) {
            this._confirmpw = value;
          }

          _checkRegistratState();
        },
      ),
    );
  }

  // 注册按钮
  Widget _registratButton() {
    return Row(
      children: [
        Expanded(
          child: RaisedButton(
            child: Text("注册"),
            color: Color(0xFF000000),
            disabledColor: Colors.black26,
            textColor: Colors.white,
            disabledTextColor: Colors.black38,
            onPressed: this._enable ? _clickEvent : null,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black, //修改颜色
          )),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: EdgeInsets.only(top: 36.0, left: 24.0, right: 24.0),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _textWidget(),
                  SizedBox(
                    height: 12.0,
                  ),
                  _accountTextField(userNameEditingController, "请输入您的用户名", 0),
                  _accountTextField(accountEditingController, "请输入您的账号", 1),
                  _passwordTextField(passwordEditingController, "请输入您的密码", 0),
                  _passwordTextField(confirmEditingController, "请再次输入您的密码", 1),
                  SizedBox(
                    height: 12.0,
                  ),
                  _registratButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
