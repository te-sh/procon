// path: arc080_b

import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), h = rd[0], w = rd[1];
  auto n = readln.chomp.to!size_t;
  auto a = readln.split.to!(int[]);

  auto k = 0;
  foreach (i; 0..h) {
    auto r = new int[](w), j = 0;
    for (;;) {
      auto m = min(a[k], w-j);
      r[j..j+m][] = k+1;
      j += m;
      a[k] -= m;
      if (a[k] == 0) ++k;
      if (j == w) break;
    }

    if (i % 2 == 0)
      foreach (c, ri; r) write(ri, c < w-1 ? " " : "");
    else
      foreach_reverse (c, ri; r) write(ri, c > 0 ? " " : "");
    writeln;
  }
}
