import 'package:flutter/material.dart';

class DetailField extends StatelessWidget {
  const DetailField({
    Key? key,
    this.title,
    this.content,
  }) : super(key: key);

  final String? title;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      width: 400,
      height: 80,
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title!,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(content!, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
