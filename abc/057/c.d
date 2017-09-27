import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long, ns = n.nsqrt;

  foreach_reverse (a; 1..ns+1)
    if (n % a == 0) {
      writeln((n/a).digits);
      break;
    }
}

auto digits(long x)
{
  foreach (i; 1..11)
    if (x / 10L ^^ i == 0) return i;
  assert(0);
}

pure T nsqrt(T)(T n)
{
  import std.algorithm, std.conv, std.range, core.bitop;
  if (n <= 1) return n;
  T m = 1 << (n.bsr / 2 + 1);
  return iota(1, m).map!"a * a".assumeSorted!"a <= b".lowerBound(n).length.to!T;
}
