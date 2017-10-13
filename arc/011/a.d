import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), m = rd[0], n = rd[1], s = rd[2];

  auto ans = s;
  while (s >= m) {
    auto t = (s / m) * n;
    ans += t;
    s = s % m + t;
  }

  writeln(ans);
}
