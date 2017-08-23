import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10 ^^ 9 + 7;

version(unittest) {} else
void main()
{
  auto s = readln.chomp.map!(a => (a - '0').to!int).array, n = s.length;
  auto m = readln.chomp.to!int;

  auto dp1 = new int[][](2, m);
  dp1[0][0] = 1;

  foreach (p; 0..n) {
    auto dp2 = dp1.map!(a => a.dup).array;
    foreach (q; 0..2)
      foreach (r; 0..m)
        if (s[p] > 0 || q == 1)
          (dp2[1][(r * 10 + s[p]) % m] += dp1[q][r]) %= mod;
    dp1 = dp2;
  }

  writeln(dp1[1][0] + s.count(0));
}
