import 'dart:async';
import 'package:atf_square/utils/app_utils.dart';
import 'package:atf_square/utils/session_manager_methods.dart';
import 'package:atf_square/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constant/colors.dart';
import 'network/base_class.dart';
import 'screen/menu/menuScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionManagerMethods.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ATF Square',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primaryColor: brandColor,
        useMaterial3:false,
        scaffoldBackgroundColor: bgColor,

        inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kEditTextCornerRadius),
                borderSide:  const BorderSide(width: 1, style: BorderStyle.solid, color: textFieldBorder)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kEditTextCornerRadius),
                borderSide: const BorderSide(width: 1, style: BorderStyle.solid,color:  textFieldBorder)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kEditTextCornerRadius),
                borderSide: const BorderSide(width: 1, color: red)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kEditTextCornerRadius),
                borderSide: const BorderSide(width:1, color: Colors.redAccent)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kEditTextCornerRadius),
                borderSide: const BorderSide(width:1, style: BorderStyle.solid, color: textFieldBorder)
            ),

            hintStyle: const TextStyle(
                color: gray,
                fontSize: 16,
                fontWeight: FontWeight.w500
            ),
        ),
        textSelectionTheme: TextSelectionThemeData(selectionColor: blue.withValues(alpha: 0.3)),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: createMaterialColor(black)).copyWith(secondary: black)
      ),
      home: const MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, });

  @override
  BaseState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends BaseState<MyHomePage> {
  @override
  void initState(){
    Timer(const Duration(milliseconds: 1400),(){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MenuScreen(),),(route) => false,);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     SystemChrome.setSystemUIOverlayStyle(
       const SystemUiOverlayStyle(
         statusBarColor: Colors.transparent,
         statusBarIconBrightness: Brightness.dark,
         systemNavigationBarColor: Colors.transparent,
         systemNavigationBarIconBrightness: Brightness.dark,
         systemNavigationBarContrastEnforced: false,
       ),
     );

    return  Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Image.asset('assets/images/logo.png',width: 180,height: 180,),
      ),
    );
  }

  @override
  void castStatefulWidget() {
    widget is MyHomePage;
  }
}
