import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;

  auto m1 = n / 2 + 1;
  auto m2 = n - n / 2 + 1;
  auto r = m1 * m2 - 1;

  writeln(r);
}
