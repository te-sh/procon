import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto k = readln.chomp.to!int;
  writeln(k == 1 || k <= n/2 ? "YES" : "NO");
}
