import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), w = rd[0], a = rd[1], b = rd[2];
  if (a > b) swap(a, b);
  writeln(b <= a+w ? 0 : b-(a+w));
}
