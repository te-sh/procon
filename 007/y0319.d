import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), a = rd[0]-1, b = rd[1];

  auto ra = calc(a);
  auto rb = calc(b);

  auto r = rb - ra, ai = digits(a);
  if (a == 1 || a > 0 && ai[0] == 2 && ai[$-1] == 1) --r;

  writeln(r);
}

auto digits(long n)
{
  int[] r;
  for (; n > 0; n /= 10) r ~= n % 10;
  r.reverse();
  return r;
}

auto calc(long a)
{
  auto ai = digits(a), n = ai.length.to!int;

  auto dp1 = new long[][][][](n+1, 2, 2, 7);
  dp1[0][0][0][0] = 1;

  foreach (i; 0..n)
    foreach (j; 0..2)
      foreach (k; 0..2)
        foreach (l; 0..7) {
          auto dm = j ? 9 : ai[i];
          foreach (d; 0..dm+1) {
            if (d == 2 && k == 1 && l < 6)
              dp1[i+1][j || d<dm][0][l+1] += dp1[i][j][1][l];
            else
              dp1[i+1][j || d<dm][d == 1][l] += dp1[i][j][k][l];
          }
        }

  auto dp2 = new long[][][][][](n+1, 2, 2, 2, 2);
  dp2[0][0][1][0][0] = 1;

  foreach (i; 0..n)
    foreach (j; 0..2)
      foreach (k; 0..2)
        foreach (l; 0..2)
          foreach (m; 0..2) {
            auto dm = j ? 9 : ai[i];
            foreach (d; 0..dm+1)
              dp2[i+1][j || d<dm][k && d == 0][l || k && d == 2][d == 2] += dp2[i][j][k][l][m];
          }

  auto r1 = 0L;
  foreach (j; 0..2)
    foreach (k; 0..2)
      foreach (l; 1..7)
        r1 += dp1[$-1][j][k][l] * l;

  auto r2 = 0L;
  foreach (j; 0..2)
    foreach (k; 0..2)
      r2 += dp2[$-1][j][k][1][1];

  return r1 + r2;
}
