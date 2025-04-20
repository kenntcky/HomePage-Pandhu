// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DetailEq extends StatelessWidget {
  
  final String headline;
  final String detailicon;
  final String detaildata;

  const DetailEq({
    Key? key,
    required this.headline,
    required this.detailicon,
    required this.detaildata
    }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // Get theme and color scheme
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                       headline,
                                        style: TextStyle(
                                          color: colorScheme.onSurface.withOpacity(0.6),
                                          fontSize: 12,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w400,
                                        ),
                                       ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            height: 24,
                                            width: 24,
                                            child: Image.asset(detailicon,
                                            fit: BoxFit.fill,
                                            )
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            detaildata,
                                            style: TextStyle(
                                              color: colorScheme.onSurface,
                                              fontSize: 16,
                                              fontFamily: 'Plus Jakarta Sans',
                                              fontWeight: FontWeight.w600,
                                              height: 0.09,
                                              ),
                                            )
                                        ],    
                                      )
                                    ],
                                  );
  }
}