// path: arc079_a

import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];
  auto c = new int[](n);
  foreach (_; 0..m) {
    auto rd2 = readln.splitter;
    auto a = rd2.front.to!size_t-1; rd2.popFront();
    auto b = rd2.front.to!size_t-1;
    if (a > b) swap(a, b);
    if (a == 0) ++c[b];
    if (b == n-1) ++c[a];
  }
  writeln(c.canFind!"a>1" ? "POSSIBLE" : "IMPOSSIBLE");
}
