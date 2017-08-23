import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;

version(unittest) {} else
void main()
{
  auto t = readln.chomp.to!size_t;

  foreach (_; 0..t) {
    auto rd = readln.split.to!(long[]), n = rd[0], m = rd[1];
    if (n >= m) {
      writeln(0);
    } else if (n == 0) {
      writeln(1 % m);
    } else if (n <= 10 ^^ 5) {
      auto r = 1L;
      foreach (i; 2..n+1)
        r = r * i % m;
      writeln(r);
    } else {
      auto minF = minFactor(m);
      if (minF == -1) {
        auto r = m - 1;
        foreach (i; n+1..m)
          r = (r * modInv(i, m) % m + m) % m;
        writeln(r);
      } else {
        if (n >= m / minF) {
          writeln(0);
        } else {
          auto r = 1L;
          foreach (i; 2..n+1)
            r = r * i % m;
          writeln(r);
        }
      }
    }
  }
}

pure T minFactor(T)(T x)
{
  auto m = x.to!real.sqrt.to!T;
  foreach (f; 2..m+1)
    if (x % f == 0) return f;
  return -1;
}

pure T modInv(T)(T x, T m)
{
  T a, b;
  exEuclid(x, m, a, b);
  return a;
}

pure T exEuclid(T)(T a, T b, ref T x, ref T y)
{
  auto g = a;
  x = 1;
  y = 0;
  if (b != 0) {
    g = exEuclid(b, a % b, y, x);
    y -= a / b * x;
  }
  return g;
}
