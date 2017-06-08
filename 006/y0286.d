import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto mi = n.iota.map!(_ => readln.chomp.to!int).array;

  auto si = new int[](1 << n), pi = new int[](1 << n);
  pi[1..$] = int.max;

  foreach (i; 1..(1 << n)) {
    auto j = i.bsf;
    si[i] = si[i.bitComp(j)] + mi[j];
  }
  si[] %= 1000;

  foreach (i; 1..(1 << n))
    foreach (j; 0..n)
      if (i.bitTest(j)) {
        auto k = i.bitComp(j);
        pi[i] = min(pi[i], pi[k] + max(mi[j] - si[k], 0));
      }

  writeln(pi[$-1]);
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
