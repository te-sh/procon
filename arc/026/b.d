import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;

  if (n == 1) {
    writeln("Deficient");
    return;
  }

  auto s = 1L;
  foreach (i; 2..n.nsqrt+1) {
    if (n % i == 0) {
      s += i;
      if (n/i != i) s += n/i;
    }
  }

  writeln(s > n ? "Abundant" : s < n ? "Deficient" : "Perfect");
}

pure T nsqrt(T)(T n)
{
  import std.algorithm, std.conv, std.range, core.bitop;
  if (n <= 1) return n;
  T m = 1 << (n.bsr / 2 + 1);
  return iota(1, m).map!"a * a".assumeSorted!"a <= b".lowerBound(n).length.to!T;
}
