import 'package:flutter/material.dart';
import '../screen/home_screen.dart';
import '../const/const.dart';


// 처음 실행시 Splash 화면
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // CurvedAnimation을 사용하여 커브를 적용
    final curvedAnimation = CurvedAnimation(
      parent: _controller!,
      curve: const Interval(0.8, 1.0, curve: Curves.easeOutCubic), // 총 Duration의 80%는 정지, 마지막 20% 동안 애니메이션
    );

    _animation = Tween(begin: 1.0, end: 0.0).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });

    _controller!.forward().then((value) =>
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()))
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _animation!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 90.0),
                child: Image.asset('asset/img/grpay2.png')),
            const SizedBox(height: 5.0),
            const Text(
              APP_TITLE,
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "QR Scanner ",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "ver $VERSION",
                  style: TextStyle(fontSize: 20.0, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            // CircularProgressIndicator(
            //   color: Color(0xFFFFC400),
            // ),
          ],
        ),
      ),
    );
  }
}
