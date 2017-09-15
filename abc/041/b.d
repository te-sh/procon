import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10 ^^ 9 + 7;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), a = rd[0], b = rd[1], c = rd[2];
  writeln((((a*b) % mod)*c) % mod);
}
