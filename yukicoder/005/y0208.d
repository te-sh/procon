import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), x = rd1[0], y = rd1[1];
  auto rd2 = readln.split.to!(int[]), x2 = rd2[0], y2 = rd2[1];

  if (x != y) {
    auto c = min(x, y);
    writeln(c + (x - c) + (y - c));
  } else {
    if (x2 == y2 && x2 < x)
      writeln(x + 1);
    else
      writeln(x);
  }
}
