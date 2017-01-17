import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto m = readln.chomp.to!size_t;

  auto qij = new int[][](n, n);
  foreach (_; m.iota) {
    auto rd = readln.split;
    auto p = rd[0].to!size_t - 1, q = rd[1].to!int, r = rd[2].to!size_t - 1;
    qij[r][p] = q;
  }

  auto memo = new int[][](n);

  auto calc(size_t i)
  {
    if (!memo[i].empty) {
      return memo[i];
    } else if (qij[i].all!"a == 0") {
      auto qi = new int[](n);
      qi[i] = 1;
      return memo[i] = qi;
    } else {
      auto qi = new int[](n);
      foreach (j, q; qij[i]) {
        if (q > 0)
          qi[] += calc(j)[] * q;
      }
      return memo[i] = qi;
    }
  }

  calc(n - 1).take(n - 1).each!writeln;
}
