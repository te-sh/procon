import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto s = new string[](n);
  foreach (i; 0..n) s[i] = readln.chomp;
  auto r = s.map!(si => si.count('R')).sum;
  auto b = s.map!(si => si.count('B')).sum;
  writeln(r > b ? "TAKAHASHI" : r < b ? "AOKI" : "DRAW");
}
