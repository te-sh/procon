import std.algorithm, std.conv, std.range, std.stdio, std.string;

const unit = [[1.0L, 0.0L], [0.0L, 1.0L]];

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];
  auto p = new size_t[](m), a = new real[](m), b = new real[](m);
  foreach (i; 0..m) {
    auto rd2 = readln.splitter;
    p[i] = rd2.front.to!size_t-1; rd2.popFront();
    a[i] = rd2.front.to!real; rd2.popFront();
    b[i] = rd2.front.to!real;
  }

  if (m == 0) {
    writeln(1);
    writeln(1);
    return;
  }

  auto q = p.dup;
  q.sort();
  size_t[size_t] z;
  auto c = size_t(0);
  foreach (qi; q.uniq) z[qi] = c++;
  foreach (ref pi; p) pi = z[pi];

  auto np = p.reduce!max;
  auto st = SegmentTree!(real[][], unit, matMul)(np+1);

  auto mi = 1.0L, ma = 1.0L;
  foreach (i; 0..m) {
    st[np-p[i]] = [[a[i], b[i]], [0.0L, 1.0L]];
    auto rn = matMulVec(st[0..$], [1.0L, 1.0L])[0];
    mi = min(mi, rn);
    ma = max(ma, rn);
  }

  writefln("%.7f", mi);
  writefln("%.7f", ma);
}

T[][] matMul(T)(const T[][] a, const T[][] b)
{
  auto l = b.length, m = a.length, n = b[0].length;
  auto c = new T[][](m, n);
  foreach (i; 0..m) {
    c[i][] = 0;
    foreach (j; 0..n)
      foreach (k; 0..l)
        c[i][j] += a[i][k] * b[k][j];
  }
  return c;
}

T[] matMulVec(T)(const T[][] a, const T[] b)
{
  auto l = b.length, m = a.length;
  auto c = new T[](m);
  c[] = 0;
  foreach (i; 0..m)
    foreach (j; 0..l)
      c[i] += a[i][j] * b[j];
  return c;
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

  pure T opSlice(size_t l, size_t r) const
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
  pure T opIndex(size_t i) { return buf[i + an]; }
}
