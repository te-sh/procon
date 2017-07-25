import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto m = readln.chomp.to!int;
  auto n = readln.chomp.to!size_t;
  auto c = readln.split.to!(int[]);

  auto dp = new int[](m+1);
  dp[1..$] = int.min;

  foreach (i; 0..n)
    foreach (j; c[i]..m+1)
      dp[j] = max(dp[j], dp[j-c[i]] + 1);

  auto p = new bool[](m+1);
  foreach (pi; primes(m)) p[pi] = true;

  auto r = 0L, ma = 0L;
  foreach (i; 0..m+1)
    if (p[i] && dp[m-i] > 0)
      r += dp[m-i];

  writeln(r + dp.maxElement);
}

pure T[] primes(T)(T n)
{
  import std.algorithm, std.bitmanip, std.conv, std.range;

  auto sieve = BitArray();
  sieve.length((n + 1) / 2);
  sieve = ~sieve;

  foreach (p; 1..((nsqrt(n) - 1) / 2 + 1))
    if (sieve[p])
      for (auto q = p * 3 + 1; q < (n + 1) / 2; q += p * 2 + 1)
        sieve[q] = false;

  auto r = sieve.bitsSet.map!(to!T).map!("a * 2 + 1").array;
  r[0] = 2;

  return r;
}

pure T nsqrt(T)(T n)
{
  import std.algorithm, std.conv, std.range, core.bitop;
  if (n <= 1) return n;
  T m = 1 << (n.bsr / 2 + 1);
  return iota(1, m).map!"a * a".assumeSorted!"a <= b".lowerBound(n).length.to!T;
}
