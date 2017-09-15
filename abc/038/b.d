import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), h1 = rd1[0], w1 = rd1[1];
  auto rd2 = readln.split.to!(int[]), h2 = rd2[0], w2 = rd2[1];
  writeln(h1 == h2 || h1 == w2 || w1 == h2 || w1 == w2 ? "YES" : "NO");
}
