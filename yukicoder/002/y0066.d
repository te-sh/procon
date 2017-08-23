import std.algorithm, std.conv, std.range, std.stdio, std.string;

// allowable-error: 10 ** -6

version(unittest) {} else
void main()
{
  auto m = readln.chomp.to!int;
  auto n = 1 << m;
  auto si = n.iota.map!(_ => readln.chomp.to!int).array;

  auto dp = new real[][](m + 1, n);
  dp[0][] = 1;
  foreach (i; 1..m+1)
    foreach (j; n.iota) {
      dp[i][j] = 0;
      foreach (k; opponents(i, j)) {
        auto s1 = si[j], s2 = si[k];
        auto p = (s1 ^^ 2).to!real / (s1 ^^ 2 + s2 ^^ 2);
        dp[i][j] += p * dp[i - 1][j] * dp[i - 1][k];
      }
    }

  writefln("%.7f", dp[m][0]);
}

auto opponents(int i, int j)
{
  auto a = (j ^ (1 << (i - 1))) & ~((1 << (i - 1)) - 1);
  auto b = a + (1 << (i - 1));
  return iota(a, b);
}
