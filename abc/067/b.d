import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], k = rd[1];
  auto l = readln.split.to!(int[]);
  l.sort!"a > b";
  writeln(l[0..k].sum);
}
