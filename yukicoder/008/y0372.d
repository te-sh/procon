import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10 ^^ 9 + 7;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto m = readln.chomp.to!int;

  auto dp1 = new int[][](2, m), dp2 = new int[][](2, m);
  dp1[0][0] = 1;

  foreach (c; s) {
    auto d = cast(int)(c-'0');
    foreach (q; 0..2) dp2[q][] = dp1[q][];
    foreach (q; 0..2)
      foreach (r; 0..m)
        if (d > 0 || q == 1)
          (dp2[1][(r * 10 + d) % m] += dp1[q][r]) %= mod;
    swap(dp1, dp2);
  }

  writeln(dp1[1][0] + s.count('0'));
}
