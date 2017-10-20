import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];

  auto cost = new int[](m), p = new real[][](m, n);
  foreach (i; 0..m) {
    p[i][] = 0;
    auto rd2 = readln.split, c = rd2[0].to!size_t, costi = rd2[1].to!int;
    cost[i] = costi;
    foreach (_; 0..c) {
      auto rd3 = readln.split, idol = rd3[0].to!size_t-1, pi = rd3[1].to!real/100;
      p[i][idol] = pi;
    }
  }

  auto e = new real[](1<<n); e[0] = 0; e[1..$][] = real.max;
  foreach (i; 1..1<<n) {
    foreach (j; 0..m) {
      auto es = real(0), qs = real(0);
      foreach (k; 0..n)
        if (i.bitTest(k)) {
          es += e[i.bitComp(k)] * p[j][k];
          qs += p[j][k];
        }
      if (qs > 0) e[i] = min(e[i], (es + cost[j]) / qs);
    }
  }

  writefln("%.7f", e[$-1]);
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
  pure T bitSet(T)(T n, size_t i) { return n | (T(1) << i); }
  pure T bitReset(T)(T n, size_t i) { return n & ~(T(1) << i); }
  pure T bitComp(T)(T n, size_t i) { return n ^ (T(1) << i); }

  import core.bitop;
  pure int bsf(T)(T n) { return core.bitop.bsf(ulong(n)); }
  pure int bsr(T)(T n) { return core.bitop.bsr(ulong(n)); }
  pure int popcnt(T)(T n) { return core.bitop.popcnt(ulong(n)); }
}
