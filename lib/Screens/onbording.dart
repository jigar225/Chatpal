import 'package:chatbot/Model/onboard.dart';
import 'package:chatbot/Screens/Authentication%202/wrapper.dart';
import 'package:chatbot/helper/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Onbording extends StatefulWidget {
  const Onbording({super.key});

  @override
  State<Onbording> createState() => _OnbordingState();
}

class _OnbordingState extends State<Onbording> {
  final list = [
    //onbording1
    Onborard(
        title: 'Welcome To Chatpal',
        subtitle:
            'Your smart companion for instant answers and seamless conversations.',
        lottie: "temp2"),
    //onbording 2
    Onborard(
        title: 'Imagination to Reality',
        subtitle: "Transform your imagination into stunning visuals",
        lottie: "onboard2"),
  ];
  final c = PageController();
  int currentpage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
            controller: c,
            physics: currentpage == list.length - 1
                ? const ClampingScrollPhysics()
                : const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                currentpage = index;
              });
            },
            itemCount: list.length,
            itemBuilder: (ctx, ind) {
              final isLast = ind == list.length - 1;
              return SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: mq.height * 0.1,
                    ),
                    Flexible(
                      child: Lottie.asset(
                          "assets/Lottifiles/${list[ind].lottie}.json",
                          height: mq.height * 0.3),
                    ),
                    Text(
                      list[ind].title,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: mq.width * 0.1,
                          vertical: mq.height * 0.02),
                      child: Text(
                        list[ind].subtitle,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: mq.height * 0.01,
                    ),
                    Wrap(
                      spacing: 10,
                      children: List.generate(
                          list.length,
                          (i) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: i == ind ? Colors.blue : Colors.grey,
                                ),
                                width: i == ind ? 15 : 10,
                                height: 5,
                              )),
                    ),
                    SizedBox(
                      height: mq.height * 0.05,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                            minimumSize:
                                Size(mq.width * 0.4, mq.height * 0.05)),
                        onPressed: () {
                          if (isLast) {
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (ontext) => Homescreen()));
                            Get.off(() => const Wrapper());
                          } else {
                            c.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);
                          }
                        },
                        child: Text(isLast ? 'Finish' : 'Next')),
                  ],
                ),
              );
            }));
  }
}
