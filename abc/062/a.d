import std.algorithm, std.conv, std.range, std.stdio, std.string;

const days = [0,31,28,31,30,31,30,31,31,30,31,30,31];

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), x = rd[0], y = rd[1];
  writeln(days[x] == days[y] ? "Yes" : "No");
}
