import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split, w = rd1[0].to!int, h = rd1[1].to!int, n = rd1[2].to!size_t;

  auto x1 = 0, x2 = w, y1 = 0, y2 = h;
  foreach (_; 0..n) {
    auto rd2 = readln.split.to!(int[]), x = rd2[0], y = rd2[1], a = rd2[2];
    switch (a) {
    case 1: x1 = max(x1, x); break;
    case 2: x2 = min(x2, x); break;
    case 3: y1 = max(y1, y); break;
    case 4: y2 = min(y2, y); break;
    default: assert(0);
    }
  }

  writeln(x1 >= x2 || y1 >= y2 ? 0 : (x2-x1) * (y2-y1));
}
