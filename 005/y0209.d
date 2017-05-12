import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto t = readln.chomp.to!size_t;

  foreach (_; 0..t) {
    auto n = readln.chomp.to!size_t;
    auto ai = readln.split.to!(int[]);

    auto dp1 = new int[int][](n);
    auto dp2 = new int[int][](n);

    int maxR(size_t i, int d)
    {
      if (d in dp1[i]) return dp1[i][d];
      auto r = 0;
      foreach (j; i+1..n) {
        auto d2 = ai[i] - ai[j];
        if (d2 > 0 && d2 < d)
          r = max(r, maxR(j, min(d2, ai[j])));
      }
      return dp1[i][d] = r + 1;
    }

    int maxL(size_t i, int d)
    {
      if (d in dp2[i]) return dp2[i][d];
      auto r = 0;
      foreach_reverse (j; 0..i) {
        auto d2 = ai[i] - ai[j];
        if (d2 > 0 && d2 < d)
          r = max(r, maxL(j, min(d2, ai[j])));
      }
      return dp2[i][d] = r + 1;
    }

    writeln(n.iota.map!(i => maxR(i, ai[i]+1) + maxL(i, ai[i]+1)).maxElement - 1);
  }
}
