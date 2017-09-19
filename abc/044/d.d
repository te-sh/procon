import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;
  auto s = readln.chomp.to!long;
  writeln(calc(n, s));
}

auto calc(long n, long s)
{
  if (n < s) return -1;
  else if (n == s) return n+1;

  auto m = n-s;
  long[] d;
  foreach (i; 1..m.nsqrt+1) {
    if (m % i == 0) {
      d ~= i;
      if (m/i != i) d ~= m/i;
    }
  }
  d.sort();

  foreach (di; d) {
    auto b = di+1, k = n, t = 0L;
    while (k > 0) {
      t += k % b;
      k /= b;
    }
    if (t == s) return b;
  }

  return -1;
}

pure T nsqrt(T)(T n)
{
  import std.algorithm, std.conv, std.range, core.bitop;
  if (n <= 1) return n;
  T m = 1 << (n.bsr / 2 + 1);
  return iota(1, m).map!"a * a".assumeSorted!"a <= b".lowerBound(n).length.to!T;
}
