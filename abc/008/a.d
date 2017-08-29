import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), s = rd[0], t = rd[1];
  writeln(t-s+1);
}
