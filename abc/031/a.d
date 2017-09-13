import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), a = rd[0], d = rd[1];
  writeln(max((a+1)*d, a*(d+1)));
}
