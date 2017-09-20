import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!size_t, x = rd[1].to!long;
  auto a = readln.split.to!(long[]);

  auto ans = 0L;
  foreach (i; 1..n) {
    auto s = a[i-1] + a[i];
    if (s <= x) continue;
    auto r = min(s - x, a[i]);
    a[i] -= r;
    ans += r;
    auto t = s - x - r;
    if (t > 0) {
      ans += t;
      a[i-1] -= t;
    }
  }

  writeln(ans);
}
