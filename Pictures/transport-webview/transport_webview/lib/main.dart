import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'),
      ],
      locale: const Locale('es'),
      title: 'Rutaticket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const WebViewExample(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  const WebViewExample({Key? key}) : super(key: key);

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  bool _isLoading = true;

  Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    return "$version+$buildNumber";
  }

  Future<void> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  @override
  void initState() {
    super.initState();
    _checkCameraPermission(); // Verifica el permiso de cámara al iniciar
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true; // Controla el retroceso si es necesario
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF673AB7),
          elevation: 0,
          toolbarHeight: 50,
          title: FutureBuilder(
            future: _getAppVersion(),
            builder: (context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Rutaticket ${snapshot.data}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                      ),
                    ),
                  ],
                );
              }
              return const Text('Cargando...');
            },
          ),
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse("https://demo.paguetodo.com/transport-public/#/init")),
              onWebViewCreated: (controller) {
                setState(() {
                  _isLoading = false;
                });
              },
              onLoadStart: (controller, url) {
                setState(() {
                  _isLoading = true;
                });
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  _isLoading = false;
                });
              },
              androidOnPermissionRequest: (controller, origin, resources) async {
                return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT,
                );
              },
            ),
            _isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:syncfusion_localizations/syncfusion_localizations.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:convert';
// import 'dart:io';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       localizationsDelegates: [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         SfGlobalLocalizations.delegate,
//       ],
//       supportedLocales: [
//         const Locale('es', 'ES'),
//       ],
//       locale: const Locale('es'),
//       title: 'Rutaticket',
//       theme: ThemeData.dark(), // Cambia a tema oscuro
//       debugShowCheckedModeBanner: false,
//       home: const WebViewExample(),
//     );
//   }
// }
//
// class WebViewExample extends StatefulWidget {
//   const WebViewExample({Key? key}) : super(key: key);
//
//   @override
//   _WebViewExampleState createState() => _WebViewExampleState();
// }
//
// class _WebViewExampleState extends State<WebViewExample> {
//   late WebViewController _controller;
//   bool _isLoading = true;
//   final ImagePicker _picker = ImagePicker();
//
//   Future<String> _getAppVersion() async {
//     final packageInfo = await PackageInfo.fromPlatform();
//     String version = packageInfo.version;
//     String buildNumber = packageInfo.buildNumber;
//     return "$version+$buildNumber";
//   }
//
//   Future<void> requestCameraPermission() async {
//     var status = await Permission.camera.status;
//     if (!status.isGranted) {
//       await Permission.camera.request();
//     }
//   }
//
//   Future<void> openCamera() async {
//     await requestCameraPermission();
//     final XFile? image = await _picker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       // Convertir la imagen a base64
//       String base64Image = base64Encode(await image.readAsBytes());
//       // Enviar la imagen en base64 de vuelta al WebView
//       _controller.runJavascript("window.onImageCaptured('$base64Image')");
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     requestCameraPermission(); // Solicitar permiso de cámara al iniciar
//     // Habilitar hybrid composition.
//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (await _controller.canGoBack()) {
//           _controller.goBack();
//           return false;
//         }
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: const Color(0xFF673AB7),
//           elevation: 0,
//           toolbarHeight: 50,
//           title: FutureBuilder(
//             future: _getAppVersion(),
//             builder: (context, AsyncSnapshot<String> snapshot) {
//               if (snapshot.connectionState == ConnectionState.done &&
//                   snapshot.hasData) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       'Rutaticket ${snapshot.data}',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 19,
//                       ),
//                     ),
//                   ],
//                 );
//               }
//               return const Text('Cargando...');
//             },
//           ),
//         ),
//         body: Stack(
//           children: [
//             WebView(
//               initialUrl: 'https://demo.paguetodo.com/transport-public/#/init',
//               javascriptMode: JavascriptMode.unrestricted,
//               onWebViewCreated: (WebViewController webViewController) {
//                 _controller = webViewController;
//                 setState(() {
//                   _isLoading = false; // Para asegurar que el controlador ha sido creado
//                 });
//               },
//               onPageStarted: (String url) {
//                 setState(() {
//                   _isLoading = true;
//                 });
//               },
//               onPageFinished: (String url) {
//                 setState(() {
//                   _isLoading = false;
//                 });
//               },
//               javascriptChannels: <JavascriptChannel>{
//                 JavascriptChannel(
//                   name: 'CameraChannel',
//                   onMessageReceived: (JavascriptMessage message) {
//                     if (message.message == 'openCamera') {
//                       openCamera();
//                     }
//                   },
//                 ),
//               },
//             ),
//             _isLoading
//                 ? Center(
//               child: CircularProgressIndicator(),
//             )
//                 : Container(),
//           ],
//         ),
//       ),
//     );
//   }
// }