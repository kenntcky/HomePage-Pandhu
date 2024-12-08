// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Panduan extends StatelessWidget {
  final String icon;
  final String text;
  final double height;

  const Panduan({
    super.key,
    required this.icon,
    required this.text,
    required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
                        height: height,
                        padding: const EdgeInsets.all(20),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              child: Image.asset(icon)
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: 
                              SizedBox(
                                child: Text(
                                    text,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.w600,
                                    ),
                                )
                              ),
                            )
                          ],
                        ),
                      );
  }
}