import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

const ma = 37294859064823L;

version(unittest) {} else
void main()
{
  auto t = readln.chomp.to!size_t;

  auto memo = new long[](14);
  foreach (i; 3..14)
    memo[i] = calcDp((10L ^^ i - 1).toArray);
  foreach (i; 4..14)
    memo[i] += memo[i-1];

  auto calcNum(long n)
  {
    auto m = n.toArray;
    auto r = calcDp(m);
    r += memo[m.length-1];
    return r;
  }

  auto calc()
  {
    auto n = readln.chomp.to!long;
    auto r = iota(1, ma+1)
      .map!(i => Tuple!(long, long)(i, calcNum(i)))
      .assumeSorted!"a[1] < b[1]"
      .equalRange(Tuple!(long, long)(0, n));
    writeln(r.front[0]);
  }

  foreach (_; 0..t) calc;
}

auto calcDp(int[] x)
{
  if (x.length < 3) return 0L;
  auto n = x.length;
  auto dp = new long[][][][](n-2, 2, 10, 10);

  auto t3 = x[0..3].toLong;
  foreach (i; 100..t3+1) {
    auto t = i.toArray;
    if (isKadomatsu(t[0], t[1], t[2]))
      ++dp[0][i == t3][t[1]][t[2]];
  }

  foreach (i; 1..n-2)
    foreach (j; 0..2)
      foreach (k; 0..10)
        foreach (l; 0..10) {
          auto maxD = j ? x[i+2] : 9;
          foreach (d; 0..maxD+1)
            if (isKadomatsu(k, l, d))
              dp[i][j && d == maxD][l][d] += dp[i-1][j][k][l];
        }

  auto r = 0L;
  foreach (j; 0..2)
    foreach (k; 0..10)
      foreach (l; 0..10)
        r += dp[$-1][j][k][l];

  return r;
}

int[] toArray(long s)
{
  if (s == 0) return [0];

  int[] r;
  for (; s > 0; s /= 10)
    r = (s % 10) ~ r;

  return r;
}

long toLong(int[] s)
{
  auto r = 0;

  foreach (si; s) {
    r *= 10;
    r += si;
  }

  return r;
}

auto isKadomatsu(int a, int b, int c)
{
  return a != b && b != c && c != a && (a > b && c > b || a < b && c < b);
}
