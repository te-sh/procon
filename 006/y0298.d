import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

// allowable-error: 10 ** -6

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];

  auto p = new real[][](n, n);
  foreach (_; 0..m) {
    auto rd2 = readln.split, u = rd2[0].to!size_t, v = rd2[1].to!size_t, q = rd2[2].to!real / 100;
    p[v][u] = q;
  }

  auto s = real(0);

  foreach (i; 0..(1 << (n-2))) {
    auto j = (i << 1).bitSet(0).bitSet(n-1);
    auto a = real(1);

    foreach (k; 1..n) {
      auto r = real(1);
      foreach (l; 0..n)
        if (j.bitTest(l) && !p[k][l].isNaN)
          r *= 1 - p[k][l];

      a *= j.bitTest(k) ? 1-r : r;
    }

    s += a;
  }

  writeln(s);
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
  pure T bitSet(T)(T n, size_t i) { return n | (T(1) << i); }
  pure T bitReset(T)(T n, size_t i) { return n & ~(T(1) << i); }
  pure T bitComp(T)(T n, size_t i) { return n ^ (T(1) << i); }
}
