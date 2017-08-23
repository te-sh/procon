import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], l = rd[1] * 60;
  auto si = readln.split.map!(s => s[0..2].to!int * 60 + s[3..5].to!int).array;

  if (l >= si.sum) {
    writeln(n);
    return;
  }

  auto dp1 = new long[][](l, n + 1);
  dp1[0][0] = 1;
  foreach (i; 0..n)
    foreach_reverse (j; si[i]..l)
      dp1[j][1..$] += dp1[j - si[i]][0..$-1];

  auto dp2 = new long[][][](n, l, n + 1);
  foreach (i; 0..n)
    foreach (j; 0..l) {
      dp2[i][j][] = dp1[j][];
      if (j >= si[i])
        dp2[i][j][1..$] -= dp2[i][j-si[i]][0..$-1];
    }

  auto fact = new real[](n + 1);
  fact[0] = 1;
  foreach (i; 1..n+1)
    fact[i] = fact[i-1] * i;

  auto r = real(0);
  foreach (j; 0..n)
    foreach (m; max(0, l-si[j])..l)
      foreach (k; 0..n) {
        auto a = dp2[j][m][k];
        r += a * fact[k] * fact[n-k-1] * (k+1);
      }

  writefln("%.10f", r / fact[n]);
}
