import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(real[]), a = rd[0], b = rd[1];

  real c;
  if (a != b) c = (a ^^ 2 - b ^^ 2).abs.sqrt;
  else        c = (a ^^ 2 + b ^^ 2).sqrt;

  writefln("%.7f", c);
}
