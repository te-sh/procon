import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto c = readln.chomp, n = c.length;

  auto b = 0;
  foreach (i, ci; c)
    if (ci == 'x') b = b.bitSet(i);
  b |= (b << n);

  auto ans = n;
  foreach (i; 0..1<<(n-1)) {
    auto p = b;
    foreach (j; 0..n-1)
      if (i.bitTest(j))
        p &= b << j;
    if ((p << (i == 0 ? 0 : i.bsr)) == 0)
      ans = min(ans, i.popcnt + 1);
  }

  writeln(ans);
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
