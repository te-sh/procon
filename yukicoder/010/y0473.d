import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], x = rd[1];

  long calc(int n, int x, int m)
  {
    if (x < m) return 0;
    if (n == 1) return 1;

    auto r = 0L;
    foreach (i; m..x.nsqrt+1) {
      if (x % i == 0)
        r += calc(n-1, x/i, i);
    }

    return r;
  }

  writeln(calc(n, x+1, 2));
}

pure T nsqrt(T)(T n)
{
  import std.algorithm, std.conv, std.range, core.bitop;
  if (n <= 1) return n;
  T m = 1 << (n.bsr / 2 + 1);
  return iota(1, m).map!"a * a".assumeSorted!"a <= b".lowerBound(n).length.to!T;
}
