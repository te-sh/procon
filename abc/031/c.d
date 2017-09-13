import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = readln.split.to!(int[]);

  auto os = new int[](n+1), es = new int[](n+1);
  foreach (i; 0..n) {
    os[i+1] = os[i] + (i % 2 == 0 ? a[i] : 0);
    es[i+1] = es[i] + (i % 2 == 1 ? a[i] : 0);
  }

  struct Score { int t, a; }

  auto calcScore(size_t i, size_t j)
  {
    if (i > j) swap(i, j);
    auto s1 = os[j+1] - os[i];
    auto s2 = es[j+1] - es[i];
    if (i % 2 == 0) return Score(s1, s2);
    else            return Score(s2, s1);
  }

  auto ans = int.min;
  foreach (pt; 0..n) {
    auto sb = Score(int.min, int.min);
    foreach (pa; 0..n) {
      if (pt == pa) continue;
      auto s = calcScore(pt, pa);
      if (s.a > sb.a) sb = s;
    }
    ans = max(ans, sb.t);
  }

  writeln(ans);
}
