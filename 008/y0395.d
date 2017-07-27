import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto a = readln.chomp.to!int;
  auto x = a - 7;
  writeln(x >= 8 ? x : -1);
}
