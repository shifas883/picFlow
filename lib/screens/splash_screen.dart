import 'package:flutter/material.dart';
import 'package:pinterest_clone/screens/dashboard.dart';

import '../common_widgets/button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Capture the moment, flow with the image.",
      "image": "https://img.freepik.com/free-vector/photo-sharing-concept-illustration_114360-275.jpg?t=st=1732980568~exp=1732984168~hmac=2b855ed2e5a7f682ebf9bc8e4f592f068092f4cedabf15249051c1e6e74abcdf&w=740"
    },
    {
      "text":
      "Where your favorite images come to life.",
      "image": "https://img.freepik.com/free-vector/photos-concept-illustration_114360-111.jpg?t=st=1732980601~exp=1732984201~hmac=f781de665abe9fa582cd4f833b8372fdc1cc22b54a2bff6265abfffb7bd433fc&w=740"
    },
    {
      "text": "Effortless image downloads, endless possibilities.",
      "image": "https://img.freepik.com/free-vector/buffer-concept-illustration_114360-2267.jpg?t=st=1732980638~exp=1732984238~hmac=2db91d6e15c9ebfd67d0290eb227b6b8222784a03947fdfc8d20444ab9691f98&w=740"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => SplashContent(
                    image: splashData[index]["image"],
                    text: splashData[index]['text'],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          splashData.length,
                              (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(right: 5),
                            height: 6,
                            width: currentPage == index ? 20 : 6,
                            decoration: BoxDecoration(
                              color: currentPage == index
                                  ?  Colors.blue
                                  : const Color(0xFFD8D8D8),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(flex: 3),
                      ConfirmButton(text: "Continue", onTap: (){
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Dashboard()),
                        );

                      }),
                      const Spacer(),
                    ],
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

class SplashContent extends StatefulWidget {
  const SplashContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  State<SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
         Text(
          "PicFlow",
          style: TextStyle(
            fontSize: 32,
            color: Colors.blue.withOpacity(0.5),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          widget.text!,
          textAlign: TextAlign.center,
        ),
        const Spacer(flex: 2),
        Image.network(
          widget.image!,
          fit: BoxFit.contain,
          height: 265,
          width: 235,
        ),
      ],
    );
  }
}
