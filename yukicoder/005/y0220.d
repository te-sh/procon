import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bigint;    // BigInt

version(unittest) {} else
void main()
{
  auto p = readln.chomp.to!long;

  auto dp1 = new long[](p);
  dp1[0] = 1;

  foreach (k; 1..p)
    dp1[k] = 10L ^^ k + dp1[k-1] * 9;

  auto dp2 = new long[][](p, 3);
  dp2[0] = [1, 0, 0];

  foreach (k; 1..p)
    foreach (m; 0..3)
      dp2[k][m] = 10L ^^ k / 3 + dp2[k-1].sum * 3 + (m == 0 ? 1 : 0);

  writeln(BigInt(10) ^^ p / 3 + dp1[$-1] - dp2[$-1][0]);
}
