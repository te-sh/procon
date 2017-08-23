import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);
  auto m = readln.chomp.to!size_t;
  auto bi = readln.split.to!(int[]);

  bi.sort!"a > b";

  auto ci = new int[](1 << n);
  foreach (p; 0..(1 << n))
    ci[p] = ai.indexed(p.bitsSet).sum;

  auto calc()
  {
    auto dp = new bool[][](m + 1, 1 << n);
    dp[0][0] = true;

    foreach (k; 0..m) {
      foreach (p1; 0..(1 << n))
        if (dp[k][p1])
          foreach (p2; 0..(1 << n))
            if ((p1 & p2) == 0 && ci[p2] <= bi[k])
              dp[k + 1][p1 | p2] = true;

      if (dp[k + 1][$-1]) return k.to!int + 1;
    }
    return -1;
  }

  writeln(calc);
}
