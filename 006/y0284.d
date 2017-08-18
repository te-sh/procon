import std.algorithm, std.conv, std.range, std.stdio, std.string;

const emptyData = Data(0, -1, -1);

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto a = new int[](n), rd = readln.chomp.splitter;
  foreach (i; 0..n) {
    a[i] = rd.front.to!int;
    rd.popFront();
  }

  compress(a);
  auto na = a.maxElement;

  auto st1 = SegmentTree!(Data[], [emptyData, emptyData], merge)(na+1);
  auto st2 = SegmentTree!(Data[], [emptyData, emptyData], merge)(na+1);

  foreach (ai; a) {
    auto m1 = st2[0..ai].exceptPrev(ai);
    auto m2 = st1[ai+1..$].exceptPrev(ai);

    if (m1.len > 0) {
      auto m11 = st2[0..m1.curr].exceptPrev(ai), m12 = st2[m1.curr+1..ai].exceptPrev(ai);
      auto m13 = max(m11, m12);
      st1[ai] = [Data(m1.len+1, ai, m1.curr), Data(m13.len+1, ai, m13.curr)];
    } else {
      st1[ai] = [Data(1, ai, -1), emptyData];
    }

    if (m2.len > 0) {
      auto m21 = st1[ai+1..m2.curr].exceptPrev(ai), m22 = st1[m2.curr+1..$].exceptPrev(ai);
      auto m23 = max(m21, m22);
      st2[ai] = [Data(m2.len+1, ai, m2.curr), Data(m23.len+1, ai, m23.curr)];
    } else {
      st2[ai] = [Data(1, ai, -1), emptyData];
    }
  }

  auto r = max(st1[0..$][0], st2[0..$][0]).len;
  writeln(r <= 2 ? 0 : r);
}

auto compress(T)(ref T[] a)
{
  auto b = a.dup.sort().uniq, c = T(0);
  T[T] d;
  foreach (bi; b) d[bi] = c++;
  foreach (ref ai; a) ai = d[ai];
}

struct Data
{
  int len;
  int curr;
  int prev;

  auto opCmp(const Data rhs) const { return len < rhs.len ? -1 : len > rhs.len ? 1 : 0; }
}

auto exceptPrev(Data[] d, int prev)
{
  return d[0].prev != prev ? d[0] : d[1];
}

auto merge(const Data[] a, const Data[] b)
{
  auto d = new Data[](2);

  if (a[0] > b[0]) {
    d[0] = a[0];
    if (a[1] > b[0])
      d[1] = a[1];
    else if (d[0].prev != b[0].prev)
      d[1] = b[0];
    else
      d[1] = max(a[1], b[1]);
  } else {
    d[0] = b[0];
    if (b[1] > a[0])
      d[1] = b[1];
    else if (d[0].prev != a[0].prev)
      d[1] = a[0];
    else
      d[1] = max(a[1], b[1]);
  }

  return d;
}

struct SegmentTree(T, T unit, alias pred = "a + b")
{
  import core.bitop, std.functional;
  alias predFun = binaryFun!pred;

  const size_t n, an;
  T[] buf;

  this(size_t n)
  {
    this.n = n;
    an = (1 << ((n - 1).bsr + 1));
    buf = new T[](an * 2);
    static if (T.init != unit) {
      buf[] = unit;
    }
  }

  this(T[] init)
  {
    this(init.length);
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

  auto opSlice(size_t l, size_t r)
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

  pure size_t opDollar() const { return n; }
  pure auto opIndex(size_t i) const { return buf[i + an]; }
}
