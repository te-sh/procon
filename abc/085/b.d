import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto d = new int[](n);
  foreach (i; 0..n) d[i] = readln.chomp.to!int;
  writeln(d.sort().uniq.walkLength);
}
