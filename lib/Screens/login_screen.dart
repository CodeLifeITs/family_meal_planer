import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_planner/Screens/home_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../Components/firebase_service.dart';
import '../Components/common_functions.dart';

final _firestore = FirebaseFirestore.instance;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscure = true;
  bool showSpinner = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          progressIndicator: const CircularProgressIndicator(
              //color: kProgressIndicatorColor,
              ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Expanded(flex: 1, child: SizedBox()),
                const Expanded(
                  flex: 2,
                  //height: 160.0,
                  child: Icon(
                    appLogo,
                    color: primaryColor,
                    size: 150,
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          FirebaseService service = FirebaseService();
                          setState(() {
                            showSpinner = true;
                          });

                          await service.signInwithGoogle().then((value) async {
                            final cellData = await _firestore
                                .collection('userData')
                                .where('email',
                                    isEqualTo: _auth.currentUser!.email)
                                .get();

                            if (cellData.docs.isEmpty) {
                              await _firestore
                                  .collection('userData')
                                  .doc(_auth.currentUser!.email)
                                  .set({
                                'email': _auth.currentUser!.email,
                                'username': _auth.currentUser!.displayName,
                              });
                            }

                            setState(() {
                              showSpinner = false;
                            });
                            pushAndRemoveUntil(context, const HomeScreen());
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 240,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: primaryColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Sign in with Google',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        fontSize: 16, color: Colors.white),
                              ),
                              const Icon(
                                Icons.g_mobiledata,
                                size: 40,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
