import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), h = rd[0], w = rd[1], n = rd[2], k = rd[3] - 1;
  writeln((h * w - 1) % n == k ? "YES" : "NO");
}
