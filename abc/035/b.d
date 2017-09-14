import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto t = readln.chomp.to!int;

  auto x = 0, y = 0, q = 0;
  foreach (c; s)
    switch (c) {
    case 'L': --x; break;
    case 'R': ++x; break;
    case 'U': --y; break;
    case 'D': ++y; break;
    case '?': ++q; break;
    default: assert(0);
    }

  auto d = x.abs + y.abs;
  if (t == 1) {
    writeln(d + q);
  } else {
    if (q < d) {
      writeln(d - q);
    } else {
      writeln((q - d) % 2 == 0 ? 0 : 1);
    }
  }
}
