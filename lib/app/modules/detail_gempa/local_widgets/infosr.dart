// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';


class infosr extends StatelessWidget {

final String satuangempa;
final String icongempa;
final String namabawah;

  const infosr({
    Key? key,
    required this.satuangempa,
    required this.icongempa,
    required this.namabawah
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                          Container(
                                            height: 24,
                                            width: 24,
                                            child: Image.asset(icongempa,
                                            fit: BoxFit.fill,
                                            )
                                            ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                           satuangempa,
                                           style: TextStyle(
                                               color: Colors.black,
                                               fontSize: 20,
                                               fontFamily: 'Plus Jakarta Sans',
                                           ),
                                        )
                                      ],
                                    ),
                                    Text(
                                     namabawah,
                                     style: TextStyle(
                                     color: Color(0xFF666666),
                                     fontSize: 12,
                                     fontFamily: 'Plus Jakarta Sans',
                                     fontWeight: FontWeight.w400,
                                     ),
                                     )
                                  ],
                                );
  }
}