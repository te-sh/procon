import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto a = readln.split("");
  auto b = readln.split("");
  writeln(a.sort() == b.sort() ? "YES" : "NO");
}
