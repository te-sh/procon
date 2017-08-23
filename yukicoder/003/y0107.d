import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto di = readln.split.to!(int[]);

  auto level(size_t s) {
    return di.indexed(s.bitsSet).count!"a < 0" + 1;
  }

  auto dp = new int[](1 << n);
  dp[0] = 100;

  foreach (i; 1..(1 << n)) {
    int maxHp;
    foreach (j; 0..n)
      if (i.bitTest(j)) {
        int hp = dp[i.bitReset(j)], nhp = 0;
        if (hp > 0) {
          if (di[j] > 0) {
            nhp = min(level(i) * 100, hp + di[j]);
          } else if (hp > -di[j]) {
            nhp = hp + di[j];
          }
          maxHp = max(maxHp, nhp);
        }
      }
    dp[i] = maxHp;
  }

  writeln(dp.back);
}

bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
T bitReset(T)(T n, size_t i) { return n & ~(T(1) << i); }

