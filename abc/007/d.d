import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), a = rd[0], b = rd[1];
  writeln(calcDp(b+1) - calcDp(a));
}

auto calcDp(long n)
{
  auto m = toArray(n), nm = m.length;

  auto dp = new long[][][](nm+1, 2, 2);
  dp[0][0][0] = 1;

  foreach (i; 0..nm)
    foreach (j; 0..2)
      foreach (k; 0..2) {
        auto dm = j ? 9 : m[i];
        foreach (d; 0..dm+1)
          dp[i+1][j || d < dm][k || d == 4 || d == 9] += dp[i][j][k];
      }

  return dp[nm][1][1];
}

auto toArray(long n)
{
  int[] m;
  for (; n > 0; n /= 10) m ~= n % 10;
  m.reverse();
  return m;
}
