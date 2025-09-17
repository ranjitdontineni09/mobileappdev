import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const ShapesDemoApp());
}

/// In-Class Activity 04 – Interactive Emoji Drawing
/// Team: [Your Names Here]
/// Notes:
/// - Task 1 uses only shapes (no lines)
/// - Task 2 draws a smiley (face, filled eyes, smile arc + small custom design)
/// - Project: Dropdown to select Party Face (side-facing) or Heart, size slider,
///   gradient background & gradient title text, responsive controls (no overflow)

class ShapesDemoApp extends StatelessWidget {
  const ShapesDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Shapes Drawing Demo',
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.blue,
    ),
    home: const ShapesDemoScreen(),
    debugShowCheckedModeBanner: false,
  );
  }
}

class ShapesDemoScreen extends StatelessWidget {
  const ShapesDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.blue, Colors.purple, Colors.pink],
          ).createShader(bounds),
          child: const Text(
            'Shapes & Emojis',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceContainerHighest
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Task 1 =====
              const Text(
                'Task 1: Basic Shapes (no lines)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: CustomPaint(
                  painter: BasicShapesPainter(),
                  size: const Size(double.infinity, 200),
                ),
              ),

              const SizedBox(height: 24),

              // ===== Task 2 =====
              const Text(
                'Task 2: Smiley (face, eyes filled, smile arc, custom design)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 240,
                child: CustomPaint(
                  painter: SmileyPainter(),
                  size: const Size(double.infinity, 240),
                ),
              ),

              const SizedBox(height: 24),

              // ===== Project: Interactive Emoji Drawing =====
              const Text(
                'Project: Interactive Emoji Drawing',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const EmojiInteractiveDemo(),

              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  Chip(label: Text('Dropdown + Slider')),
                  Chip(label: Text('CustomPainter')),
                  Chip(label: Text('Gradients')),
                  Chip(label: Text('Party Face (side)')),
                  Chip(label: Text('Heart Path')),
                  Chip(label: Text('Star Shape')),
                  Chip(label: Text('Diamond Shape')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== Task 1: Basic Shapes (no lines) ====================
class BasicShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final squareOffset = Offset(cx - 80, cy);
    final circleOffset = Offset(cx, cy);
    final arcOffset = Offset(cx + 80, cy);
    final rectOffset = Offset(cx - 160, cy);
    final ovalOffset = Offset(cx + 160, cy);

    // Square
    final squarePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromCenter(center: squareOffset, width: 60, height: 60),
      squarePaint,
    );

    // Circle
    final circlePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    canvas.drawCircle(circleOffset, 30, circlePaint);

    // Arc
    final arcPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawArc(
      Rect.fromCenter(center: arcOffset, width: 60, height: 60),
      0,
      2.1,
      false,
      arcPaint,
    );

    // Rectangle
    final rectPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromCenter(center: rectOffset, width: 80, height: 40),
      rectPaint,
    );

    // Replacement for the old "line": a purple arc (still a shape)
    final smallArcPaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    final smallArcRect = Rect.fromCenter(
      center: Offset(cx - 200, cy),
      width: 60,
      height: 60,
    );
    canvas.drawArc(smallArcRect, pi * 0.2, pi * 0.6, false, smallArcPaint);

    // Oval
    final ovalPaint = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: ovalOffset, width: 80, height: 40),
      ovalPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==================== Task 2: Smiley (front-facing) ====================
class SmileyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = min(size.width, size.height) * 0.35;

    // soft radial background
    final bgRect = Offset.zero & size;
    final bgPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.topLeft,
        radius: 1.2,
        colors: [Colors.amber.shade50, Colors.white],
      ).createShader(bgRect);
    canvas.drawRect(bgRect, bgPaint);

    // Face (filled)
    final faceRect = Rect.fromCircle(center: c, radius: r);
    final facePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.yellow.shade300, Colors.orange.shade200],
      ).createShader(faceRect);
    canvas.drawCircle(c, r, facePaint);

    // Eyes (filled)
    final eyePaint = Paint()..color = Colors.brown.shade900;
    final ex = r * 0.35;
    final ey = r * -0.15;
    canvas.drawCircle(c + Offset(-ex, ey), r * 0.10, eyePaint);
    canvas.drawCircle(c + Offset(ex, ey), r * 0.10, eyePaint);

    // Smile (arc)
    final smileRect = Rect.fromCenter(center: c + Offset(0, r * 0.18), width: r * 1.2, height: r * 0.9);
    final smilePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.10
      ..strokeCap = StrokeCap.round
      ..color = Colors.brown.shade800;
    canvas.drawArc(smileRect, pi * 0.15, pi * 0.7, false, smilePaint);

    // Custom: blush
    final blush = Paint()..color = Colors.pinkAccent.withOpacity(0.35);
    canvas.drawCircle(c + Offset(-ex, ey + r * 0.35), r * 0.12, blush);
    canvas.drawCircle(c + Offset(ex, ey + r * 0.35), r * 0.12, blush);

    // Small party hat
    final hatHeight = r * 0.6;
    final hatPath = Path()
      ..moveTo(c.dx, c.dy - r - 4)
      ..lineTo(c.dx - r * 0.5, c.dy - r + hatHeight)
      ..lineTo(c.dx + r * 0.5, c.dy - r + hatHeight)
      ..close();
    final hatPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.pinkAccent, Colors.purple],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(c.dx - r, c.dy - r, 2 * r, hatHeight));
    canvas.drawPath(hatPath, hatPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==================== Project: Interactive Emoji Drawing ====================
enum EmojiType { partyFace, heart, star, diamond }

class EmojiInteractiveDemo extends StatefulWidget {
  const EmojiInteractiveDemo({super.key});

  @override
  State<EmojiInteractiveDemo> createState() => _EmojiInteractiveDemoState();
}

class _EmojiInteractiveDemoState extends State<EmojiInteractiveDemo> {
  EmojiType selected = EmojiType.partyFace;
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Responsive controls — no overflow
            Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                const Text('Emoji:'),
                DropdownButton<EmojiType>(
                  value: selected,
                  items: const [
                    DropdownMenuItem(
                      value: EmojiType.partyFace,
                      child: Text('Party Face 🎉'),
                    ),
                    DropdownMenuItem(
                      value: EmojiType.heart,
                      child: Text('Heart ❤️'),
                    ),
                    DropdownMenuItem(
                      value: EmojiType.star,
                      child: Text('Star ⭐'),
                    ),
                    DropdownMenuItem(
                      value: EmojiType.diamond,
                      child: Text('Diamond 💎'),
                    ),
                  ],
                  onChanged: (v) => setState(() => selected = v ?? selected),
                ),
                const Text('Size:'),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 160, maxWidth: 260),
                  child: Slider(
                    value: scale,
                    min: 0.6,
                    max: 1.6,
                    onChanged: (v) => setState(() => scale = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Clipped canvas — no bleed past rounded corners
            AspectRatio(
              aspectRatio: 1.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomPaint(
                  painter: EmojiPainter(selected, scale: scale),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmojiPainter extends CustomPainter {
  final EmojiType type;
  final double scale;
  EmojiPainter(this.type, {this.scale = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    // background
    final bgRect = Offset.zero & size;
    final bgPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.topLeft,
        radius: 1.2,
        colors: [Colors.amber.shade50, Colors.white],
      ).createShader(bgRect);
    canvas.drawRect(bgRect, bgPaint);

    final c = Offset(size.width / 2, size.height / 2);
    final base = (min(size.width, size.height) * 0.32) * scale;

    switch (type) {
      case EmojiType.partyFace:
        _drawPartyFaceSide(canvas, c, base); // side-facing with hat above eyes
        break;
      case EmojiType.heart:
        _drawHeart(canvas, c, base * 1.15);
        break;
      case EmojiType.star:
        _drawStar(canvas, c, base);
        break;
      case EmojiType.diamond:
        _drawDiamond(canvas, c, base);
        break;
    }
  }

  /// SIDE-FACING (right-looking) party face with hat above the eyes.
  void _drawPartyFaceSide(Canvas canvas, Offset c, double r) {
    // Face
    final faceRect = Rect.fromCircle(center: c, radius: r);
    final facePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.yellow.shade300, Colors.orange.shade200],
      ).createShader(faceRect);
    canvas.drawCircle(c, r, facePaint);

    // Eyes (near eye larger, far eye smaller) -> looking to the RIGHT
    final nearEye = c + Offset(r * 0.22, -r * 0.12);
    final farEye  = c + Offset(r * 0.02, -r * 0.10);
    // near eye (opaque)
    canvas.drawCircle(nearEye, r * 0.11, Paint()..color = Colors.brown.shade900);
    // far eye (slightly transparent) — opacity applied to Color, not Paint
    canvas.drawCircle(farEye,  r * 0.07, Paint()..color = Colors.brown.shade900.withOpacity(0.95));

    // Small nose (triangle), pointing right
    final nosePath = Path()
      ..moveTo(c.dx + r * 0.10, c.dy)               // base left
      ..lineTo(c.dx + r * 0.28, c.dy - r * 0.04)    // tip up-right
      ..lineTo(c.dx + r * 0.10, c.dy + r * 0.04)    // base down-left
      ..close();
    final nosePaint = Paint()..color = Colors.brown.shade700;
    canvas.drawPath(nosePath, nosePaint);

    // Smile (arc) shifted to the right side of the face
    final smileRect = Rect.fromCenter(
      center: c + Offset(r * 0.18, r * 0.18),
      width: r * 1.0,
      height: r * 0.75,
    );
    final smilePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.10
      ..strokeCap = StrokeCap.round
      ..color = Colors.brown.shade800;
    canvas.drawArc(smileRect, pi * 0.12, pi * 0.70, false, smilePaint);

    // Party hat ABOVE THE EYES (slightly shifted right to sit over near eye)
    final hatBottomY = c.dy - r * 0.35; // above eyes
    final hatHalfW   = r * 0.60;
    final hatShiftX  = r * 0.12;        // shift over near eye
    final hatPath = Path()
      ..moveTo(c.dx + hatShiftX, c.dy - r * 1.05)                 // apex
      ..lineTo(c.dx - hatHalfW + hatShiftX, hatBottomY)           // left base
      ..lineTo(c.dx + hatHalfW + hatShiftX, hatBottomY)           // right base
      ..close();
    final hatPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.pinkAccent, Colors.purple],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(c.dx - r, c.dy - r, 2 * r, r));
    canvas.drawPath(hatPath, hatPaint);

    // Optional thin brim just above the eyes
    final brimPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.06;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(c.dx + hatShiftX, hatBottomY + r * 0.02), width: r * 1.1, height: r * 0.9),
      pi * 0.95,
      pi * 0.50,
      false,
      brimPaint,
    );

    // Single blush on the near cheek (since side-facing)
    final blush = Paint()..color = Colors.pinkAccent.withOpacity(0.35);
    canvas.drawCircle(c + Offset(r * 0.26, r * 0.18), r * 0.12, blush);

    // Confetti — kept closer so it stays inside the clipped canvas
    final confettiColors = [
      Colors.redAccent,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.deepOrangeAccent,
      Colors.purpleAccent,
      Colors.tealAccent,
    ];
    final rand = Random(7);
    for (int i = 0; i < 22; i++) {
      final angle = rand.nextDouble() * 2 * pi;
      final dist = r * (1.15 + rand.nextDouble() * 0.5);
      final pos = c + Offset(cos(angle) * dist, sin(angle) * dist);
      final color = confettiColors[i % confettiColors.length];
      final p = Paint()..color = color.withOpacity(0.9);
      final t = i % 3;
      final s = r * (0.06 + (rand.nextDouble() * 0.05));
      switch (t) {
        case 0:
          canvas.drawCircle(pos, s * 0.6, p);
          break;
        case 1:
          canvas.drawRect(Rect.fromCenter(center: pos, width: s, height: s), p);
          break;
        default:
          final path = Path()
            ..moveTo(pos.dx, pos.dy - s)
            ..lineTo(pos.dx + s, pos.dy)
            ..lineTo(pos.dx, pos.dy + s)
            ..lineTo(pos.dx - s, pos.dy)
            ..close();
          canvas.drawPath(path, p);
      }
    }
  }

  void _drawHeart(Canvas canvas, Offset c, double r) {
    final path = Path();
    final top = c + Offset(0, -r * 0.15);
    final leftCtrl = c + Offset(-r, -r);
    final rightCtrl = c + Offset(r, -r);
    final bottom = c + Offset(0, r);

    path.moveTo(top.dx, top.dy);
    path.cubicTo(leftCtrl.dx, leftCtrl.dy, c.dx - r, c.dy + r * 0.3, bottom.dx, bottom.dy);
    path.cubicTo(c.dx + r, c.dy + r * 0.3, rightCtrl.dx, rightCtrl.dy, top.dx, top.dy);

    final heartRect = Rect.fromCircle(center: c, radius: r * 1.2);
    final fill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.red.shade400, Colors.pink.shade200],
      ).createShader(heartRect);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.08
      ..color = Colors.red.shade900;

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  void _drawStar(Canvas canvas, Offset c, double r) {
    final path = Path();
    final points = 5; // Number of points for the star
    final outerRadius = r;
    final innerRadius = r * 0.4;
    
    for (int i = 0; i < points * 2; i++) {
      final radius = i % 2 == 0 ? outerRadius : innerRadius;
      final angle = pi / points * i;
      final x = c.dx + radius * cos(angle - pi / 2);
      final y = c.dy + radius * sin(angle - pi / 2);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    
    final fill = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.8,
        colors: [Colors.yellow.shade700, Colors.orange],
      ).createShader(Rect.fromCircle(center: c, radius: r));
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.05
      ..color = Colors.orange.shade900;

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
    
    // Add sparkle effect
    final sparklePaint = Paint()..color = Colors.white.withOpacity(0.8);
    canvas.drawCircle(c + Offset(-r * 0.6, -r * 0.6), r * 0.08, sparklePaint);
    canvas.drawCircle(c + Offset(r * 0.5, -r * 0.7), r * 0.06, sparklePaint);
    canvas.drawCircle(c + Offset(r * 0.7, r * 0.4), r * 0.07, sparklePaint);
  }

  void _drawDiamond(Canvas canvas, Offset c, double r) {
    final path = Path();
    final diamondWidth = r * 1.2;
    final diamondHeight = r * 1.4;
    
    path.moveTo(c.dx, c.dy - diamondHeight / 2); // Top
    path.lineTo(c.dx + diamondWidth / 2, c.dy); // Right
    path.lineTo(c.dx, c.dy + diamondHeight / 2); // Bottom
    path.lineTo(c.dx - diamondWidth / 2, c.dy); // Left
    path.close();
    
    final fill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.cyan.shade400, Colors.blue.shade700],
      ).createShader(Rect.fromCircle(center: c, radius: r * 1.5));
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.06
      ..color = Colors.blue.shade900;

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
    
    // Add shine effect
    final shinePath = Path();
    final shineSize = r * 0.3;
    shinePath.moveTo(c.dx - r * 0.2, c.dy - r * 0.2);
    shinePath.lineTo(c.dx - r * 0.1, c.dy - r * 0.3);
    shinePath.lineTo(c.dx + r * 0.1, c.dy - r * 0.1);
    shinePath.lineTo(c.dx, c.dy);
    shinePath.close();
    
    final shinePaint = Paint()..color = Colors.white.withOpacity(0.7);
    canvas.drawPath(shinePath, shinePaint);
  }

  @override
  bool shouldRepaint(covariant EmojiPainter oldDelegate) {
    return oldDelegate.type != type || oldDelegate.scale != scale;
  }
}