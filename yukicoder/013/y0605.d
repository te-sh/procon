import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto a = readln.chomp.to!real;
  auto b = readln.chomp.to!real;

  writefln("%.7f", PI * 2 * (b - a));
}
