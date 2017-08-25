import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]);
  auto xa = rd[0], ya = rd[1], xb = rd[2], yb = rd[3], xc = rd[4], yc = rd[5];

  auto x1 = xb-xa, y1 = yb-ya, x2 = xc-xa, y2 = yc-ya;
  writefln("%f", (x1*y2 - x2*y1).abs.to!real / 2);
}
