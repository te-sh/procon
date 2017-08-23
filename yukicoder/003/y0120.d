import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto t = readln.chomp.to!size_t;

  foreach (_; t.iota) {
    auto n = readln.chomp.to!int;
    auto li = readln.split.to!(int[]);

    auto calc(int[] li) {
      int[int] cnt;
      foreach (l; li) ++cnt[l];

      auto ci = cnt.values;
      if (ci.length < 3) return 0;
      ci.sort!"a > b";

      auto k1 = ci[0];
      if (k1 <= n / 3) return n / 3;

      auto k2 = ci[1];
      if (k2 <= (n - k1) / 2) return (n - k1) / 2;

      return n - k1 - k2;
    }

    writeln(calc(li));
  }
}
