import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10^^9+7;
alias mint = FactorRing!mod;
alias Mat = mint[][];
auto mh = 10;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto h = readln.split.to!(int[]);
  auto d = readln.chomp.to!int;
  auto s = new int[](d);
  auto t = new int[](d);
  foreach (i; 0..d) {
    auto rd = readln.split.to!(int[]), si = rd[0]-1, ti = rd[1]-1;
    s[i] = si;
    t[i] = ti;
  }

  auto u = (s ~ t).sort().uniq.array, nu = u.length;

  auto ns = 1;
  foreach (i; 1..nu) {
    if (u[i] - u[i-1] > 1) ++ns;
    ++ns;
  }

  auto m = new Mat[](ns);
  m[0] = buildMat(h[u[0]]);
  
  int[int] buf;
  buf[u[0]] = 0;
  auto v = 1;
  foreach (i; 1..nu) {
    if (u[i] - u[i-1] > 1) m[v++] = buildMuledMat(h[u[i-1]+1..u[i]]);
    buf[u[i]] = v;
    m[v++] = buildMat(h[u[i]]);
  }

  foreach (ref si; s) si = buf[si];
  foreach (ref ti; t) ti = buf[ti];

  auto st = SegmentTree!(Mat, matMul)(m, unit());

  foreach (i; 0..d) {
    auto r = st[s[i]..t[i]];
    writeln(r[0][0]);
  }
}

auto unit()
{
  auto m = new mint[][](mh, mh);
  foreach (i; 0..mh)
    foreach (j; 0..mh)
      m[i][j] = 0;
  foreach (i; 0..mh) m[i][i] = 1;
  return m;
}

auto buildMuledMat(int[] h)
{
  auto m = buildMat(h[0]);
  foreach (hi; h[1..$])
    m = matMul(m, buildMat(hi));
  return m;
}

auto buildMat(int h)
{
  auto m = new mint[][](mh, mh);
  foreach (i; 0..mh)
    foreach (j; 0..mh)
      m[i][j] = 0;
  foreach (i; 0..h) m[0][i] = 1;
  foreach (i; 0..mh-1) m[i+1][i] = 1;
  return m;
}

T[][] matMul(T)(const T[][] a, const T[][] b)
{
  auto l = b.length, m = a.length, n = b[0].length;
  auto c = new T[][](m, n);
  foreach (i; 0..m) {
    static if (T.init != 0) c[i][] = 0;
    foreach (j; 0..n)
      foreach (k; 0..l)
        c[i][j] += a[i][k] * b[k][j];
  }
  return c;
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

struct FactorRing(int m, bool pos = false)
{
  version(BigEndian) {
    union { long vl; struct { int vi2; int vi; } }
  } else {
    union { long vl; int vi; }
  }

  static init() { return FactorRing!(m, pos)(0); }

  @property int toInt() { return vi; }
  alias toInt this;

  this(int v) { vi = v; }
  this(int v, bool runMod) { vi = runMod ? mod(v) : v; }
  this(long v) { vi = mod(v); }

  ref FactorRing!(m, pos) opAssign(int v) { vi = v; return this; }

  pure auto mod(int v) const
  {
    static if (pos) return v % m;
    else return (v % m + m) % m;
  }

  pure auto mod(long v) const
  {
    static if (pos) return cast(int)(v % m);
    else return cast(int)((v % m + m) % m);
  }

  static if (!pos) {
    pure auto opUnary(string op: "-")() const { return FactorRing!(m, pos)(mod(-vi)); }
  }

  static if (m < int.max / 2) {
    pure auto opBinary(string op: "+")(int rhs) const { return FactorRing!(m, pos)(mod(vi + rhs)); }
    pure auto opBinary(string op: "-")(int rhs) const { return FactorRing!(m, pos)(mod(vi - rhs)); }
  } else {
    pure auto opBinary(string op: "+")(int rhs) const { return FactorRing!(m, pos)(mod(vl + rhs)); }
    pure auto opBinary(string op: "-")(int rhs) const { return FactorRing!(m, pos)(mod(vl - rhs)); }
  }
  pure auto opBinary(string op: "*")(int rhs) const { return FactorRing!(m, pos)(mod(vl * rhs)); }

  pure auto opBinary(string op)(FactorRing!(m, pos) rhs) const
    if (op == "+" || op == "-" || op == "*") { return opBinary!op(rhs.vi); }

  static if (m < int.max / 2) {
    auto opOpAssign(string op: "+")(int rhs) { vi = mod(vi + rhs); }
    auto opOpAssign(string op: "-")(int rhs) { vi = mod(vi - rhs); }
  } else {
    auto opOpAssign(string op: "+")(int rhs) { vi = mod(vl + rhs); }
    auto opOpAssign(string op: "-")(int rhs) { vi = mod(vl - rhs); }
  }
  auto opOpAssign(string op: "*")(int rhs) { vi = mod(vl * rhs); }

  auto opOpAssign(string op)(FactorRing!(m, pos) rhs)
    if (op == "+" || op == "-" || op == "*") { return opOpAssign!op(rhs.vi); }
}
