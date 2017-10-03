import std.algorithm, std.conv, std.range, std.stdio, std.string;

const s = [0, 1, 2, 3, 2, 1, 2, 3, 3, 2];

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), a = rd[0], b = rd[1];
  if (a > b) swap(a, b);
  auto c = b-a;
  writeln(c/10 + s[c%10]);
}
