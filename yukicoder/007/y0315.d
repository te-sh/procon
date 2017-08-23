import std.algorithm, std.conv, std.range, std.stdio, std.string;

const p = 10 ^^ 9 + 7;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split;
  auto rd2 = rd1[0..2].map!(s => s.map!(c => (c - '0').to!int).array), a = rd2[0], b = rd2[1];
  auto p = rd1[2].to!int;

  auto sp = p.predSwitch(8, 0, 80, 1, 800, 2);
  auto r = calc8!true(b, sp);
  auto s = calc8!false(a, sp);
  r.sub(s);
  writeln(r);
}

auto calc8(bool includeMax)(int[] ai, int sp)
{
  auto n = ai.length.to!int;
  if (n <= sp + 3) return calcNaive!(includeMax)(ai, sp);

  auto dp1 = new int[][][](2, 2, 3);
  dp1[0][0][0] = 1;

  foreach (i; 0..n-sp-3) {
    auto dp2 = new int[][][](2, 2, 3);
    foreach (j; 0..2)
      foreach (k; 0..2)
        foreach (l; 0..3) {
          int lim = j ? 9 : ai[i];
          foreach (d; 0..lim+1)
            dp2[j || d < lim][k || d == 3][(l + d) % 3].add(dp1[j][k][l]);
          }
    dp1 = dp2;
  }

  auto dp3 = new int[][][][](2, 2, 3, 2);
  foreach (j; 0..2)
    foreach (k; 0..2)
      foreach (l; 0..3) {
        int lim = j ? 999 : ai[$-sp-3..$-sp].toInt;
        foreach (d; 0..lim+1)
          dp3[j || d < lim][k || d.include3][(l + d) % 3][d % 8 == 0].add(dp1[j][k][l]);
      }

  auto dp4 = new int[][][][][](2, 2, 3, 2, 2);
  if (sp > 0)
    foreach (j; 0..2)
      foreach (k; 0..2)
        foreach (l; 0..3)
          foreach (m; 0..2) {
            int lim = j ? 10 ^^ sp - 1 : ai[$-sp..$].toInt;
            foreach (d; 0..lim+1)
              dp4[j || d < lim][k || d.include3][(l + d) % 3][m][d % (10 ^^ sp) == 0].add(dp3[j][k][l][m]);
          }

  auto jMin = includeMax ? 0 : 1, r = 0;

  foreach (j; jMin..2)
    foreach (k; 0..2)
      foreach (l; 0..3)
        foreach (m; 0..2)
          if (sp == 0) {
            if ((k == 1 || l == 0) && m == 0)
              r.add(dp3[j][k][l][m]);
          } else {
            foreach (p; 0..2)
              if ((k == 1 || l == 0) && (m == 0 || p == 0))
                r.add(dp4[j][k][l][m][p]);
          }

  return r;
}

auto calcNaive(bool includeMax)(int[] ai, int sp)
{
  auto n = ai.toInt, r = 0;
  if (!includeMax) --n;
  foreach (i; 1..n+1)
    if ((i % 3 == 0 || i.include3) && i % (8 * (10 ^^ sp)) != 0)
      ++r;
  return r;
}

auto include3(int n)
{
  for (; n > 0; n /= 10)
    if (n % 10 == 3) return true;
  return false;
}

auto toInt(int[] ai)
{
  auto r = 0;
  foreach (a; ai) r = r * 10 + a;
  return r;
}

auto add(ref int a, int b) { a = (a + b) % p; }
auto sub(ref int a, int b) { a = ((a - b) % p + p) % p; }
