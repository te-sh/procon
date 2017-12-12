import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.random;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], q = rd[1];

  auto p = primes!int(5*10^^7)[10000..$];
  auto b = p.randomSample(n).array;

  auto bc = new long[](n+1);
  foreach (i; 0..n) bc[i+1] = bc[i] + b[i];

  int[long] h;
  h[0] = 0;

  auto curr = 0L;
  foreach (i; 0..q) {
    auto line = readln.chomp;
    if (line[0] == '?') {
      writeln(h[curr]);
    } else {
      auto rd2 = line[2..$].splitter;
      auto l = rd2.front.to!int; rd2.popFront();
      auto r = rd2.front.to!int; rd2.popFront();
      auto k = rd2.front.to!int;
      curr += (bc[r] - bc[l]) * k;
      if (curr !in h)
        h[curr] = i+1;
    }
  }
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
