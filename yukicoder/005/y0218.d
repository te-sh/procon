import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto a = readln.chomp.to!int;
  auto b = readln.chomp.to!int;
  auto c = readln.chomp.to!int;

  auto nn = (a + b - 1) / b;
  auto nc = (a + c - 1) / c;

  writeln(3 * nc <= 2 * nn ? "YES" : "NO");
}
