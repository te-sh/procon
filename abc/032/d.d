import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto rd1 = readln.split, n = rd1[0].to!size_t, wl = rd1[1].to!long;
  auto v = new long[](n), w = new long[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.split.to!(long[]);
    v[i] = rd2[0];
    w[i] = rd2[1];
  }

  auto calc1()
  {
    auto n1 = (n+1)/2, n2 = n-n1;

    struct VW { long v, w, maxV; }
    auto vw2 = new VW[](1<<n2);

    foreach (i; 0..1<<n2) {
      auto vs = v[n1..$].indexed(i.bitsSet).sum;
      auto ws = w[n1..$].indexed(i.bitsSet).sum;
      vw2[i] = VW(vs, ws);
    }

    auto vw2s = vw2.sort!"a.w < b.w";
    vw2s[0].maxV = vw2s[0].v;
    foreach (i; 1..1<<n2) vw2s[i].maxV = max(vw2s[i].v, vw2s[i-1].maxV);

    auto getMaxV(long w)
    {
      auto r = vw2s.lowerBound(VW(0, w+1, 0));
      return r.empty ? 0 : r.back.maxV;
    }

    auto maxV = getMaxV(wl);
    foreach (i; 0..1<<n1) {
      auto vs = v.indexed(i.bitsSet).sum;
      auto ws = w.indexed(i.bitsSet).sum;
      if (ws <= wl)
        maxV = max(maxV, getMaxV(wl-ws) + vs);
    }

    return maxV;
  }

  auto calc2()
  {
    auto ws = w.sum;
    auto dp = new long[][](n+1, ws+1);
    dp[0][0] = 1;

    foreach (i; 0..n)
      foreach (j; 0..ws+1) {
        dp[i+1][j] = dp[i][j];
        if (j >= w[i] && dp[i][j-w[i]])
          dp[i+1][j] = max(dp[i+1][j], dp[i][j-w[i]] + v[i]);
      }

    return dp[n][0..min(ws, wl)+1].reduce!max - 1;
  }

  auto calc3()
  {
    auto vs = v.sum;
    auto dp = new long[][](n+1, vs+1);

    foreach (i; 0..n+1) dp[i][] = long.max;
    dp[0][0] = 0;

    foreach (i; 0..n)
      foreach (j; 0..vs+1) {
        dp[i+1][j] = dp[i][j];
        if (j >= v[i] && dp[i][j-v[i]] != long.max)
          dp[i+1][j] = min(dp[i+1][j], dp[i][j-v[i]] + w[i]);
      }

    foreach_reverse (j; 0..vs+1)
      if (dp[n][j] <= wl) return j;

    return 0;
  }

  if (n <= 30)
    writeln(calc1);
  else if (w.reduce!max <= 1000)
    writeln(calc2);
  else
    writeln(calc3);
}
