import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto k = readln.chomp.to!int;
  auto s = readln.chomp.to!int;
  writeln(100 * s / (100 - k));
}
