import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

// path: arc075_a

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto s = new int[](n);
  foreach (i; 0..n) s[i] = readln.chomp.to!int;
  auto t = s.sum;

  auto dp = BitArray();
  dp.length = t+1;
  dp[0] = true;

  foreach (i; 0..n+1) {
    auto dp2 = dp.dup;
    dp2.lshift(s[i]);
    dp |= dp2;
  }

  foreach_reverse (i; 0..t+1)
    if (dp[i] && i % 10 != 0) {
      writeln(i);
      return;
    }

  writeln(0);
}

auto lshift(ref BitArray ba, size_t n)
{
  if (n % 64 == 0) {
    if (n > 0) {
      ba <<= 1;
      ba <<= n-1;
    }
  } else {
    ba <<= n;
  }
}
