import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

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

int[] primes(int n)
{
  auto sieve = new bool[]((n + 1) / 2);
  sieve[] = true;

  foreach (p; iota(1, (n.to!real.sqrt.to!int - 1) / 2 + 1))
    if (sieve[p])
      foreach (q; iota(p * 3 + 1, (n + 1) / 2, p * 2 + 1))
        sieve[q] = false;

  auto r = sieve.enumerate
    .filter!("a[1]")
    .map!("a[0]").map!("a * 2 + 1")
    .map!(to!int).array;
  r[0] = 2;

  return r;
}
