import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto ma = 10^^5;
  auto p = primes(10^^5);

  auto b = new bool[](ma+1);
  foreach (pi; p) b[pi] = true;

  auto c = new bool[](ma+1);
  foreach (i; 0..ma+1) c[i] = (i&1) && b[i] && b[(i+1)/2];

  auto d = new int[](ma+1);
  foreach (i; 0..ma+1) d[i] = d[i-1]+c[i];

  auto q = readln.chomp.to!int;
  foreach (_; 0..q) {
    auto rd = readln.splitter;
    auto l = rd.front.to!int-1; rd.popFront();
    auto r = rd.front.to!int;
    writeln(d[r]-d[l]);
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
