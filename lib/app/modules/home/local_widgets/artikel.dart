// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Artikel extends StatelessWidget {
  const Artikel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 288,
      width: 202,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset("asset/img/image/artikel.png")),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pandhu',
                  style: TextStyle(
                    color: Color(0xFFF6643C),
                    fontSize: 10,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '10 Sep 2024',
                  style: TextStyle(
                    color: Color(0xFF636363),
                    fontSize: 10,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                    'Bagaimana\nCara Evakuasi Diri',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Indonesia adalah salah satu bagian yang termasuk dalam Rings of Fire (ROF). Namun naasnya, banyak sekali warga yang',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF636363),
                      fontSize: 10,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 43,
                        height: 15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Baca',
                              style: TextStyle(
                                color: Color(0xFF3BABF6),
                                fontSize: 10,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Image.asset("asset/img/icon/arrow-right.png"),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
