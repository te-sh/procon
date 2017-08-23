import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;

version(unittest) {} else
void main()
{
  auto x = readln.chomp.to!int;
  auto y = readln.chomp.to!int;
  auto l = readln.chomp.to!int;

  auto a = 0;
  a += (x.abs + l - 1) / l;
  a += (y.abs + l - 1) / l;

  if (y >= 0 && x != 0) a += 1;
  if (y < 0) a += 2;

  writeln(a);
}
