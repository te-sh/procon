import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), c1 = rd[0], c2 = rd[1], c3 = rd[2], c4 = rd[3];
  auto r = (c2 * c3 - c1 * c4) ^^ 2 - 4 * (c3 ^^ 2 - c2 * c4) * (c2 ^^ 2 - c1 * c3);
  writeln(r > 0 ? "R" : "I");
}
