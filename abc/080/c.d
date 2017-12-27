import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto f = new int[](n);
  foreach (i; 0..n) f[i] = readln.split.to!(int[]).toBit;
  auto p = new int[][](n, 11);
  foreach (i; 0..n) p[i] = readln.split.to!(int[]);

  auto ans = long.min;
  foreach (i; 1..1<<10) {
    auto r = 0;
    foreach (j; 0..n)
      r += p[j][(i&f[j]).popcnt];
    ans = max(ans, r);
  }

  writeln(ans);
}

auto toBit(int[] a)
{
  auto r = 0;
  foreach (i, ai; a)
    if (ai) r = r.bitSet(i);
  return r;
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
  pure T bitSet(T)(T n, size_t i) { return n | (T(1) << i); }
  pure T bitReset(T)(T n, size_t i) { return n & ~(T(1) << i); }
  pure T bitComp(T)(T n, size_t i) { return n ^ (T(1) << i); }

  pure T bitSet(T)(T n, size_t s, size_t e) { return n | ((T(1) << e) - 1) & ~((T(1) << s) - 1); }
  pure T bitReset(T)(T n, size_t s, size_t e) { return n & (~((T(1) << e) - 1) | ((T(1) << s) - 1)); }
  pure T bitComp(T)(T n, size_t s, size_t e) { return n ^ ((T(1) << e) - 1) & ~((T(1) << s) - 1); }

  import core.bitop;
  pure int bsf(T)(T n) { return core.bitop.bsf(ulong(n)); }
  pure int bsr(T)(T n) { return core.bitop.bsr(ulong(n)); }
  pure int popcnt(T)(T n) { return core.bitop.popcnt(ulong(n)); }
}
