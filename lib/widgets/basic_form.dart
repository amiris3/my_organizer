import 'package:flutter/material.dart';
import '../styling.dart';

class BasicForm extends StatelessWidget {
  final formKey;
  final List<Widget> widgets;
  final ElevatedButton button;

  BasicForm({this.widgets, this.button, this.formKey});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: mainGradient,
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Builder(
              builder: (context) => Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (Widget widget in widgets)
                        Container(
                          margin: EdgeInsets.all(8),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: widget,
                        ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 24.0, horizontal: 24.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: button,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
