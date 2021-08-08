import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math'as math;
final lineProvider = ChangeNotifierProvider((ref) => LineService());
class LineService extends ChangeNotifier{
  List<Line> lines = [];
  void calculate(double bx,double by ,double x,double y,Size size){
    final width = size.width;
    bx = width /2;
    by = size.height * .15;
    double m = (y - by)/(x-bx);
    // print(m);
    lines.clear();
    double angle = math.atan(m) * 180/3.14;
    double dx = - width/2;
    if(x > bx)
      dx = width/2;
    double dy = m * (dx);
    if(math.sqrt(angle * angle) < 30 || dy > 0){
      return;
    }
    lines.add(Line(start: Offset(bx,by), end: Offset(dx,dy)));
    double lx  = dx;
    double ly = dy;
    dx = 2*dx*(-1);
    m = m*(-1);
    dy = m * (dx);
    lines.add(Line(start: Offset(lx,ly), end: Offset(dx,dy)));

    notifyListeners();
  }
}
class Line{
  Offset start;
  Offset end;
  Line({required this.start,required this.end});

  @override
  String toString() {
    return 'Line{start: $start, end: $end}';
  }
}