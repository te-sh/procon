import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], k = rd[1];
  auto pi = readln.split.to!(long[]);
  auto bi = readln.split.to!(long[]);

  if (k == 0) {
    writeln(0);
    return;
  }

  auto l = dist(pi, bi), r = l;

  auto changeDigits(long[] pi)
  {
    foreach_reverse (i; 0..n-1)
      if (pi[i] < pi[i+1])
        return n-i-1;
    return n;
  }

  foreach (_; 0..k-1) {
    auto d = changeDigits(pi);
    if (d == n) {
      pi.reverse();
      l = dist(pi, bi);
    } else {
      l -= dist(pi[$-d-1..$], bi[$-d-1..$]);
      auto qi = pi[$-d..$];
      qi.reverse();
      auto c = pi[$-d-1];
      auto e = qi.assumeSorted.upperBound(c);
      swap(pi[$-d-1], e.front);
      l += dist(pi[$-d-1..$], bi[$-d-1..$]);
    }
    r += l;
  }

  writeln(r);
}

auto dist(long[] pi, long[] bi)
{
  return zip(pi, bi).map!(a => abs(a[0] - a[1])).sum;
}
