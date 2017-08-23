import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1], k = rd1[2];
  auto gij = new int[][](n, n);
  foreach (_; 0..m) {
    auto rd2 = readln.split.to!(size_t[]), u = rd2[0] - 1, v = rd2[1] - 1;
    gij[u][v] = gij[v][u] = 1;
  }

  auto wij = gij.warshalFloyd;

  auto calc(size_t[] ai)
  {
    auto l = ai.length;

    auto dp = new int[][](1 << l, l);
    foreach (i; 0..(1 << l)) dp[i][] = int.max;
    dp[0][0] = 0;

    foreach (i; 1..(1 << l)) {
      foreach (j1; 0..l) {
        if (!i.bitTest(j1)) continue;
        if (i.bitComp(j1) == 0) {
          if (wij[0][ai[j1]]) dp[i][j1] = wij[0][ai[j1]];
        } else {
          foreach (j2; 0..l) {
            if (j1 == j2 || !i.bitTest(j2) || !wij[ai[j1]][ai[j2]]) continue;
            dp[i][j1] = min(dp[i][j1], dp[i.bitComp(j1)][j2] + wij[ai[j1]][ai[j2]]);
          }
        }
      }
    }

    return dp[$-1].any!(a => a <= k);
  }

  size_t[] ai;
  foreach_reverse (i; 1..n) {
    if (calc(ai ~ i))
      ai ~= i;
    if (ai.length >= k)
      break;
  }

  writeln(ai.map!(a => 2 ^^ a - 1).sum);
}

import std.traits;

T[][] warshalFloyd(T)(const T[][] a)
  if (isNumeric!T)
{
  import std.algorithm;

  auto n = a.length;

  auto b = new T[][](n);
  foreach (i; 0..n) b[i] = a[i].dup;

  foreach (k; 0..n)
    foreach (i; 0..n)
      foreach (j; 0..n)
        if ((i == k || b[i][k]) && (k == j || b[k][j])) {
          auto s = b[i][k] + b[k][j];
          if (i == j || b[i][j])
            b[i][j] = min(b[i][j], s);
          else
            b[i][j] = s;
        }

  return b;
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
  pure T bitSet(T)(T n, size_t i) { return n | (T(1) << i); }
  pure T bitReset(T)(T n, size_t i) { return n & ~(T(1) << i); }
  pure T bitComp(T)(T n, size_t i) { return n ^ (T(1) << i); }
}
