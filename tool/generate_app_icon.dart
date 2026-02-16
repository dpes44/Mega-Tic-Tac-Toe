import 'dart:io';

import 'package:image/image.dart' as img;

void main() {
  const int size = 1024;
  final img.Image icon = img.Image(width: size, height: size);

  // Deep navy background.
  img.fill(icon, color: img.ColorRgb8(30, 39, 56));

  // Subtle inner panel.
  const int inset = 90;
  img.fillRect(
    icon,
    x1: inset,
    y1: inset,
    x2: size - inset,
    y2: size - inset,
    color: img.ColorRgb8(41, 53, 76),
  );

  // Warm gold board frame.
  const int boardInset = 190;
  const int boardStroke = 24;
  final img.Color boardColor = img.ColorRgb8(207, 163, 91);

  img.drawRect(
    icon,
    x1: boardInset,
    y1: boardInset,
    x2: size - boardInset,
    y2: size - boardInset,
    color: boardColor,
    thickness: boardStroke,
  );

  final int boardSize = size - (boardInset * 2);
  final int cell = boardSize ~/ 3;

  // Grid lines.
  for (int i = 1; i <= 2; i++) {
    final int x = boardInset + (cell * i);
    final int y = boardInset + (cell * i);
    img.drawLine(
      icon,
      x1: x,
      y1: boardInset,
      x2: x,
      y2: size - boardInset,
      color: boardColor,
      thickness: 14,
    );
    img.drawLine(
      icon,
      x1: boardInset,
      y1: y,
      x2: size - boardInset,
      y2: y,
      color: boardColor,
      thickness: 14,
    );
  }

  // X mark (top-left cell).
  const int markPad = 58;
  final img.Color xColor = img.ColorRgb8(203, 94, 94);
  img.drawLine(
    icon,
    x1: boardInset + markPad,
    y1: boardInset + markPad,
    x2: boardInset + cell - markPad,
    y2: boardInset + cell - markPad,
    color: xColor,
    thickness: 24,
  );
  img.drawLine(
    icon,
    x1: boardInset + cell - markPad,
    y1: boardInset + markPad,
    x2: boardInset + markPad,
    y2: boardInset + cell - markPad,
    color: xColor,
    thickness: 24,
  );

  // O mark (bottom-right cell).
  final img.Color oColor = img.ColorRgb8(111, 156, 230);
  final int oCx = boardInset + (cell * 2) + (cell ~/ 2);
  final int oCy = boardInset + (cell * 2) + (cell ~/ 2);
  img.fillCircle(
    icon,
    x: oCx,
    y: oCy,
    radius: 78,
    color: oColor,
  );
  img.fillCircle(
    icon,
    x: oCx,
    y: oCy,
    radius: 56,
    color: img.ColorRgb8(41, 53, 76),
  );

  // Highlight in center cell.
  img.fillCircle(
    icon,
    x: boardInset + (cell * 1) + (cell ~/ 2),
    y: boardInset + (cell * 1) + (cell ~/ 2),
    radius: 34,
    color: img.ColorRgb8(236, 205, 143),
  );

  final File output = File('assets/branding/app_icon.png');
  output.parent.createSync(recursive: true);
  output.writeAsBytesSync(img.encodePng(icon, level: 9));
  stdout.writeln('Generated ${output.path}');
}
