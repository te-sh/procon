import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

alias Mat = Matrix!real;

version(unittest) {} else
void main()
{
  long n; int m; readV(n, m);
  auto p = new long[](m), a = new real[](m), b = new real[](m);
  foreach (i; 0..m) {
    readV(p[i], a[i], b[i]); --p[i];
  }

  if (m == 0) {
    writeln(1);
    writeln(1);
    return;
  }

  auto q = p.dup;
  q.sort();
  int[long] z;
  auto c = 0;
  foreach (qi; q.uniq) z[qi] = c++;
  foreach (ref pi; p) pi = z[pi];

  auto np = p.reduce!max;
  auto st = SegmentTree!(Mat, "a*b")(np+1, Mat.unit(2));

  auto mi = 1.0L, ma = 1.0L;
  foreach (i; 0..m) {
    st[np-p[i]] = Mat([[a[i], b[i]], [0.0L, 1.0L]]);
    auto rn = (st[0..$] * [1.0L, 1.0L])[0];
    mi = min(mi, rn);
    ma = max(ma, rn);
  }

  writefln("%.7f", mi);
  writefln("%.7f", ma);
}

struct Matrix(T)
{
  size_t r, c;
  T[][] a;
  alias a this;

  static ref auto unit(size_t n)
  {
    auto r = Matrix!T(n, n);
    foreach (i; 0..n) r[i][i] = 1;
    return r;
  }

  this(size_t r, size_t c)
  {
    this.r = r; this.c = c;
    a = new T[][](r, c);
    static if (T.init != 0) foreach (i; 0..r) a[i][] = 0;
  }

  this(T[][] b)
  {
    r = b.length;
    c = b[0].length;
    a = b;
  }

  ref auto dup() { auto x = Matrix!T(r, c); foreach (i; 0..r) x[i][] = a[i][]; return x; }

  ref auto opBinary(string op)(Matrix!T b) if (op == "+" || op == "-") in { assert(r == b.r && c == b.c); } body
  {
    auto x = Matrix!T(r, c);
    foreach (i; 0..r) foreach (j; 0..c) x[i][j] = mixin("a[i][j]"~op~"b[i][j]");
    return x;
  }

  ref auto opBinary(string op: "*")(Matrix!T b) in { assert(c == b.r); } body
  {
    auto x = Matrix!T(r, b.c);
    foreach (i; 0..r) foreach (j; 0..b.c) foreach (k; 0..c) x[i][j] += a[i][k]*b[k][j];
    return x;
  }

  ref auto opBinary(string op: "*")(T[] b) in { assert(c == b.length); } body
  {
    auto x = new T[](r);
    static if (T.init != 0) x[] = 0;
    foreach (i; 0..r) foreach (j; 0..c) x[i] += a[i][j]*b[j];
    return x;
  }                                                                             
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
    an = (1 << ((n-1).bsr + 1));
    buf = new T[](an*2);
    if (T.init != unit) buf[] = unit;
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
      buf[i] = predFun(buf[i*2], buf[i*2+1]);
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

  pure T opIndex(size_t i) { return buf[i+an]; }
  pure size_t opDollar() { return n; }
}
