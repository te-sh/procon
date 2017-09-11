import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto r = new int[](n);
  foreach (i; 0..n) r[i] = readln.chomp.to!int;

  r.sort!"a > b";
  auto ans = 0;
  foreach (int i, ri; r) ans += ri ^^ 2 * (-1) ^^ i;

  writefln("%.7f", ans.to!real * PI);
}
