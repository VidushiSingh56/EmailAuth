//
//
// import 'package:flutter/material.dart';
// import 'wrapper.dart'; // Import the Wrapper class
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           alignment: Alignment.center,
//           color: const Color.fromRGBO(255, 255, 255, 1.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "OnLearner",
//                 style: TextStyle(
//                   color: Color(0xFFA18030),
//                   fontSize: 35,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             Image(
//               width: 250,
//               image: AssetImage('assets/images/Brain tech logo design 1.png'),
//               errorBuilder: (context, error, stackTrace) {
//                 return const Icon(
//                   Icons.broken_image,
//                   size: 250,
//                   color: Colors.white,
//                 );
//               },
//             ),
//
//               Text("Let's Get Started",
//               style: TextStyle(
//                 color: Colors.black87,
//                 fontSize: 23,
//                 fontWeight: FontWeight.bold
//               ),
//               ),
//
//               SizedBox(height: 15),
//               Text("Never a better time than now to start",
//                 style: TextStyle(
//                     color: Color(0xFFA79E9E),
//                     fontSize: 17,
//                     fontWeight: FontWeight.bold
//                 ),
//               ),
//               SizedBox(height: 50),
//               SizedBox(
//                 width: 290,
//                 height: 60,
//                 child : ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => Wrapper()),
//                     );
//
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.amber,
//                     minimumSize: const Size(double.infinity, 50),
//                   ),
//                   child: const Text(
//                     "Get Started",
//                     style: TextStyle(color: Colors.white, fontSize: 20),
//                   ),
//                 ),
//
//               )
//             ],
//           ),
//         ),
//       ),
//
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'wrapper.dart'; // Import the Wrapper class

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _animateToFinalPosition = false;

  @override
  void initState() {
    super.initState();

    // Start the animation after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _animateToFinalPosition = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Container
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: const Color.fromRGBO(255, 255, 255, 1.0),
          ),

          // Centered Column with Animation
          AnimatedPositioned(
            duration: const Duration(seconds: 3),
            curve: Curves.easeInOut,
            top: _animateToFinalPosition ? 150 : MediaQuery.of(context).size.height / 2 - 100,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // App Title
                Text(
                  "OnLearner",
                  style: const TextStyle(
                    color: Color(0xFFA18030),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Logo Image
                Image(
                  width: 250,
                  image: const AssetImage('assets/images/Brain tech logo design 1.png'),
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 250,
                      color: Colors.white,
                    );
                  },
                ),

                // Additional Contents (Text and Button)
                if (_animateToFinalPosition)
                  AnimatedOpacity(
                    duration: const Duration(seconds: 2),
                    opacity: _animateToFinalPosition ? 1.0 : 0.0,
                    child: Column(
                      children: [
                        const SizedBox(height: 50), // Space between the image and the text
                        Text(
                          "Let's Get Started",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Never a better time than now to start",
                          style: const TextStyle(
                            color: Color(0xFFA79E9E),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 50),
                        SizedBox(
                          width: 290,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Wrapper()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text(
                              "Get Started",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



