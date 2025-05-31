import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQrCode extends StatelessWidget {
  const GenerateQrCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: QrImageView(
        data: '6836d98a01713b035c79712b',
        size: 280,
        embeddedImageStyle: QrEmbeddedImageStyle(size: const Size(100, 100)),
      ),
    );
  }
}
