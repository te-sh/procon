import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;

  auto r = long.max, fn = factors(n);
  foreach (p; fn) {
    if (n / p < p * p) break;
    auto m = n / p;
    foreach (qb; fn) {
      if (qb % p != 0) continue;
      auto q = qb / p;
      if (m / q < q) break;
      r = min(r, p + q + m/q - 3);
    }
  }

  writeln(r, " ", n-1);
}

auto factors(long n)
{
  auto r = [1L, n];

  foreach (i; 2..n.nsqrt+1)
    if (n % i == 0) r ~= [i, n/i];

  r.sort();
  return r;
}

pure T nsqrt(T)(T n)
{
  import std.algorithm, std.conv, std.range, core.bitop;
  if (n <= 1) return n;
  T m = 1 << (n.bsr / 2 + 1);
  return iota(1, m).map!"a * a".assumeSorted!"a <= b".lowerBound(n).length.to!T;
}

pure T ncbrt(T)(T n)
{
  import std.algorithm, std.conv, std.range, core.bitop;
  if (n <= 1) return n;
  T m = 1 << (n.bsr / 3 + 1);
  return iota(1, m).map!"a * a * a".assumeSorted!"a <= b".lowerBound(n).length.to!T;
}
