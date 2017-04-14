import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);
  writeln(calc(ai));
}

int calc(int[] ai)
{
  auto ma = 5_000_000;

  auto pi = primes(ma);
  auto s = ai.map!toBitNum.fold!"a | b";
  auto t = ~s & ((1 << 10) - 1);

  auto r = -1, i = 0;
  while (i < pi.length) {
    while (toBitNum(pi[i]) & t) {
      if (++i >= pi.length) return r;
    }

    auto j = i;
    while (!(toBitNum(pi[j]) & t)) {
      if (j++ >= pi.length - 1) break;
    }

    if (pi[i..j].map!toBitNum.fold!"a | b" == s) {
      auto p1 = i == 0 ? 1 : pi[i - 1] + 1;
      auto p2 = j == pi.length ? ma : pi[j] - 1;
      r = max(r, p2 - p1);
    }

    i = j + 1;
  }

  return r;
}

int toBitNum(int a)
{
  if (a == 0) return 1;

  int r = 0;
  for (; a != 0; a /= 10)
    r |= (1 << a % 10);
  return r;
}

pure int[] primes(int n)
{
  import std.math, std.bitmanip;

  auto sieve = BitArray();
  sieve.length((n + 1) / 2);
  sieve = ~sieve;

  foreach (p; 1..((n.to!real.sqrt.to!int - 1) / 2 + 1))
    if (sieve[p])
      for (auto q = p * 3 + 1; q < (n + 1) / 2; q += p * 2 + 1)
        sieve[q] = false;

  auto r = sieve.bitsSet.map!(to!int).map!("a * 2 + 1").array;
  r[0] = 2;

  return r;
}
