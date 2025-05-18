import 'package:flutter/material.dart';




class Round extends StatelessWidget {
  final String image;
  final String text;
  
  const Round({
  super.key,
  required this.image,
  required this.text,
  });

  @override
  Widget build(BuildContext context) {
    // Get current theme data
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.surface,
                              ),
                              child: Image.asset(image),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              text,
                              style: TextStyle(
                                color: colorScheme.onBackground.withOpacity(0.6),
                                fontSize: 14,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        );
  }
}