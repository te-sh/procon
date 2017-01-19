import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), f0 = rd[0], f1 = rd[1], n = rd[2];
  auto f = [f0, f1, f0 ^ f1];
  writeln(f[n % 3]);
}
