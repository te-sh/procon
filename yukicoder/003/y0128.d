import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;
  auto m = readln.chomp.to!long;

  writeln(n / 1000 / m * 1000);
}
