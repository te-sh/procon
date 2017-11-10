import std.algorithm, std.conv, std.range, std.stdio, std.string;

const inf = 10L ^^ 15;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], l = rd[1];
  struct Light { int l, r, c; }
  auto a = new Light[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.splitter;
    auto li = rd2.front.to!int; rd2.popFront();
    auto ri = rd2.front.to!int; rd2.popFront();
    auto ci = rd2.front.to!int;
    a[i] = Light(li, ri, ci);
  }

  a.sort!"a.l < b.l";

  auto dp = new long[](l);
  dp[1..$] = inf;
  auto st = SegmentTree!(long, min)(dp, inf);

  foreach (ai; a)
    st[ai.r] = min(st[ai.r], st[ai.l..ai.r+1] + ai.c);

  writeln(st[l]);
}

struct SegmentTree(T, alias pred = "a + b")
{
  import core.bitop, std.functional;
  alias predFun = binaryFun!pred;

  const size_t n, an;
  T[] buf;
  T unit;

  this(size_t n, T unit = T.init)
  {
    this.n = n;
    this.unit = unit;
    an = (1 << ((n - 1).bsr + 1));
    buf = new T[](an * 2);
    if (T.init != unit) {
      buf[] = unit;
    }
  }

  this(T[] init, T unit = T.init)
  {
    this(init.length, unit);
    buf[an..an+n][] = init[];
    foreach_reverse (i; 1..an)
      buf[i] = predFun(buf[i*2], buf[i*2+1]);
  }

  void opIndexAssign(T val, size_t i)
  {
    buf[i += an] = val;
    while (i /= 2)
      buf[i] = predFun(buf[i * 2], buf[i * 2 + 1]);
  }

  pure T opSlice(size_t l, size_t r)
  {
    l += an; r += an;
    T r1 = unit, r2 = unit;
    while (l != r) {
      if (l % 2) r1 = predFun(r1, buf[l++]);
      if (r % 2) r2 = predFun(buf[--r], r2);
      l /= 2; r /= 2;
    }
    return predFun(r1, r2);
  }

  pure size_t opDollar() { return n; }
  pure T opIndex(size_t i) { return buf[i + an]; }
}
