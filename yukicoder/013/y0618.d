import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

version(unittest) {} else
void main()
{
  auto qn = readln.chomp.to!int;

  struct Query { int t; long x; }

  auto q = new Query[](qn);
  foreach (i; 0..qn) {
    auto rd = readln.splitter;
    auto t = rd.front.to!int; rd.popFront();
    auto x = rd.front.to!long;
    q[i] = Query(t, x);
  }

  long[] y;
  auto xs = 0L;
  foreach (qi; q)
    switch (qi.t) {
    case 1:
      y ~= qi.x-xs;
      break;
    case 2:
      break;
    case 3:
      xs += qi.x;
      break;
    default:
      assert(0);
    }

  y = y.sort().uniq.array;
  auto ys = y.assumeSorted;

  int[long] za;
  foreach (int i, yi; y) za[yi] = i;

  auto bt = BiTree!int(y.length), n = 0;
  xs = 0L;
  int[] ord;

  auto calc(long l)
  {
    auto x2 = ys.lowerBound(l-xs).length;
    return bt[x2..$] < l;
  }

  foreach (qi; q) {
    switch (qi.t) {
    case 1:
      auto x2 = za[qi.x-xs];
      bt[x2] += 1;
      ord ~= x2;
      ++n;
      break;
    case 2:
      auto x2 = ord[qi.x-1];
      bt[x2] += -1;
      --n;
      break;
    case 3:
      xs += qi.x;
      break;
    default:
      assert(0);
    }

    if (n == 0) {
      writeln(0);
    } else {
      auto bsearch = iota(0, n+1).map!(l => tuple(l, calc(l))).assumeSorted!"a[1] < b[1]";
      auto r = bsearch.lowerBound(tuple(0, true));
      writeln(r.back[0]);
    }
  }
}

struct BiTree(T)
{
  const size_t n;
  T[] buf;

  this(size_t n)
  {
    this.n = n;
    this.buf = new T[](n + 1);
  }

  void opIndexOpAssign(string op: "+")(T val, size_t i)
  {
    ++i;
    for (; i <= n; i += i & -i)
      buf[i] += val;
  }

  pure T opSlice(size_t r, size_t l) const
  {
    return get(l) - get(r);
  }

  pure size_t opDollar() const { return n; }
  pure T opIndex(size_t i) const { return opSlice(i, i+1); }

private:

  pure T get(size_t i) const
  {
    auto s = T(0);
    for (; i > 0; i -= i & -i)
      s += buf[i];
    return s;
  }
}
