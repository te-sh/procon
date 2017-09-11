import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split, n = rd1[0].to!size_t, a = rd1[1].to!int, b = rd1[2].to!int;

  auto p = 0;

  foreach (_; 0..n) {
    auto rd2 = readln.split, s = rd2[0], d = rd2[1].to!int;
    auto dir = s == "West" ? -1 : +1;

    if      (d < a) p += a * dir;
    else if (d > b) p += b * dir;
    else            p += d * dir;
  }

  if      (p < 0) writeln("West ", -p);
  else if (p > 0) writeln("East ", p);
  else            writeln(p);
}
