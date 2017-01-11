import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  auto a = 1, c = 0;
  for (; a < n; a <<= 1) ++c;

  writeln(c);
}
