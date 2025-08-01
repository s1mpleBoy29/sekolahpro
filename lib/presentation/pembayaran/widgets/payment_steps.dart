import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PaymentSteps extends StatelessWidget {
  final int stepsekarang;

  const PaymentSteps({
    super.key,
    required this.stepsekarang,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme theme = Theme.of(context).colorScheme;
    final Color activeColor = theme.primary; // A nice deep purple
    final Color inactiveColor = theme.outlineVariant; // A light grey

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: Row(
        children: [
          // Tagihan
          _buildStep(
            icon: Icons.receipt_outlined,
            label: 'Tagihan',
            isActive: stepsekarang == 0,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),

          _buildConnector(inactiveColor: inactiveColor),

          // Pembayaran
          _buildStep(
            icon: LucideIcons.creditCard,
            label: 'Pembayaran',
            isActive: stepsekarang == 1,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),

          _buildConnector(inactiveColor: inactiveColor),

          // Upload
          _buildStep(
            icon: LucideIcons.fileUp,
            label: 'Upload',
            isActive: stepsekarang == 2,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final color = isActive ? activeColor : inactiveColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // Helper untuk connector dotted line
  Widget _buildConnector({required Color inactiveColor}) {
    return Expanded(
      child: Container(
        height: 20.0,
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        child: CustomPaint(
          painter: DottedLinePainter(color: inactiveColor),
        ),
      ),
    );
  }
}

// CustomPainter untuk dotted line
class DottedLinePainter extends CustomPainter {
  final Color color;
  DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    const double dashWidth = 2.0;
    const double dashSpace = 2.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
