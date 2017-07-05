import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

const th = 10 ^^ 5;

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!size_t, x = rd[1].to!long;
  auto a = readln.split.to!(long[]);

  auto bt = a.enumerate.filter!((e) => e[1] < th);
  auto b = bt.map!"a[1]".array, bi = bt.map!"a[0]".array, nb = b.length, tb = b.sum;

  auto ct = a.enumerate.filter!((e) => e[1] >= th);
  auto c = ct.map!"a[1]".array, ci = ct.map!"a[0]".array, nc = c.length;

  auto dpb = new BitArray[](nb+1);
  dpb[0].length(tb+1);
  dpb[0][0] = true;

  foreach (i; 0..nb) {
    dpb[i+1] = dpb[i].dup;
    if (b[i].popcnt == 1 && b[i] > 1) {
      dpb[i+1] <<= 1;
      dpb[i+1] <<= b[i]-1;
    } else {
      dpb[i+1] <<= b[i];
    }
    dpb[i+1] |= dpb[i];
  }

  auto calcDPrev(long x)
  {
    auto r = BitArray();
    r.length = nb;

    foreach_reverse (i; 0..nb) {
      if (x >= b[i] && dpb[i][x-b[i]]) {
        r[i] = true;
        x -= b[i];
      }
    }

    return r;
  }

  if (c.empty) {
    if (x <= tb && dpb[$-1][x]) {
      auto r = calcDPrev(x), st = "";
      foreach (i; 0..n)
        st ~= r[i] ? "o" : "x";
      writeln(st);
    } else {
      writeln("No");
    }
  } else {
    auto dpc = new long[](1 << nc);
    foreach (i; 0..(1 << nc)) {
      if (i > 0) {
        auto j = i.bsf;
        dpc[i] = dpc[i.bitComp(j)] + c[j];
      }
      auto s = x - dpc[i];
      if (s >= 0 && s <= tb && dpb[$-1][s]) {
        auto r = calcDPrev(s), st = "";
        foreach (k; 0..n) {
          auto ib = bi.countUntil(k);
          if (ib >= 0) {
            st ~= r[ib] ? "o" : "x";
          } else {
            auto ic = ci.countUntil(k);
            st ~= i.bitTest(ic) ? "o" : "x";
          }
        }
        writeln(st);
        return;
      }
    }
    writeln("No");
  }
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
