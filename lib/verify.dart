// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:projectemailauthdec1/login.dart';
// import 'package:projectemailauthdec1/wrapper.dart';
//
// class Verify extends StatefulWidget {
//   const Verify({super.key});
//
//   @override
//   State<Verify> createState() => _VerifyState();
// }
//
// class _VerifyState extends State<Verify> {
//   @override
//   void initState() {
//     sendVerifyLink();
//     super.initState();
//   }
//
//   sendVerifyLink() async {
//     final user = FirebaseAuth.instance.currentUser;
//     await user?.sendEmailVerification().then((value) {
//       Get.snackbar(
//         'Link Sent',
//         'A link has been sent to your email',
//         margin: EdgeInsets.all(30),
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     });
//   }
//
//   reload() async {
//     await FirebaseAuth.instance.currentUser!.reload().then((value) {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null && user.emailVerified) {
//         Get.offAll(Wrapper()); // Navigate to the wrapper page if verified
//       } else {
//         Get.snackbar(
//           'Verification',
//           'Email verification failed. Please check your email and try again.',
//           margin: EdgeInsets.all(30),
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Verification"),
//         backgroundColor: Color(0xE7F6E107), // ARGB format
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Get.offAll(() => Login()); // Replace 'LoginScreen' with your first page
//             Get.snackbar(
//               "Verification Failed",
//               "Please try again.",
//               margin: EdgeInsets.all(20),
//               snackPosition: SnackPosition.BOTTOM,
//             );
//           },
//         ),
//
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Center(
//           child: Text(
//             "Open your mail and click on the link provided to verify your email. Then reload this page.",
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => reload(),
//         child: Icon(Icons.autorenew_rounded),
//       ),
//     );
//   }
// }
