import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions
import std.typecons;  // Tuple, Nullable, BigFlags

version(unittest) {} else
void main()
{
  auto m = readln.chomp.to!int;
  foreach (_; 0..m) {
    auto rd = readln.splitter;
    auto a = rd.front.to!real; rd.popFront();
    auto b = rd.front.to!real; rd.popFront();
    auto t = rd.front.to!real;

    if (b == 0) {
      writefln("%.10f", t ^^ (1.0L/a));
      continue;
    } else if (a == 0) {
      writefln("%.10f", E ^^ (t ^^ (1.0L/b)));
      continue;
    }

    auto r = a / b * t ^^ (1.0L / b);

    auto eps = 1.0e-10L, x1 = 100.0L;
    for (;;) {
      auto lx = log(x1);
      auto x2 = x1 - (x1 * lx - r) / (lx + 1);
      if ((x2 - x1).abs < eps) break;
      x1 = x2;
    }

    writefln("%.10f", x1 ^^ (b/a));
  }
}
