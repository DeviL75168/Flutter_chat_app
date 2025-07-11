import 'package:flutter/material.dart';
import 'dart:math';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('password generator'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  String password = generateRandomPassword();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Generated Password'),
                        content: SelectableText(password),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Generate Random Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String generateRandomPassword() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#%^&*()-_=+';
    Random rnd = Random(DateTime.now().millisecondsSinceEpoch);
    return String.fromCharCodes(
      Iterable.generate(
        12,
            (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      ),
    );
  }
}
