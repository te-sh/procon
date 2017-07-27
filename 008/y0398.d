import std.algorithm, std.conv, std.range, std.stdio, std.string;

const combi = pascalTriangle!int(6);

version(unittest) {} else
void main()
{
  auto x = (readln.chomp.to!real * 4).to!int;

  auto dp = new long[][][](101, 5, 401);
  foreach (i; 0..101) {
    dp[i][0][0] = 1;
    foreach (j; 1..5)
      foreach (k; 1..401)
        foreach (m; 1..i+1)
          if (k >= m)
            dp[i][j][k] += dp[i][j-1][k-m];
  }

  auto r = 0L;
  foreach (i; 0..100)
    foreach (j; i+1..101)
      foreach (ni; 1..6)
        foreach (nj; 1..7-ni) {
          auto m = 6 - ni - nj;
          auto y = x - (ni - 1) * i - (nj - 1) * j - m * i;
          if (y < 0) continue;
          r += dp[j - i - 1][m][y] * combi[6][ni] * combi[6-ni][nj];
        }

  if (x % 4 == 0) ++r;

  writeln(r);
}

pure T[][] pascalTriangle(T)(size_t n)
{
  auto t = new T[][](n + 1);
  t[0] = new T[](1);
  t[0][0] = 1;
  foreach (i; 1..n+1) {
    t[i] = new T[](i + 1);
    t[i][0] = t[i][$-1] = 1;
    foreach (j; 1..i)
      t[i][j] = t[i - 1][j - 1] + t[i - 1][j];
  }
  return t;
}
