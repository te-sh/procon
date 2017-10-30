import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto d = readln.split.to!(int[]);
  writeln(d[3] || d[0..3].count(1) < 2 ? "SURVIVED" : "DEAD");
}
