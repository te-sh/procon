import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto l = readln.chomp.to!int;
  auto n = readln.chomp.to!int;
  readln;

  writeln(8 ^^ (l / 3 - 1) * n);
}
