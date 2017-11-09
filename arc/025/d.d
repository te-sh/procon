import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10^^9+7;
alias mint = FactorRing!mod;
alias Mat = mint[][];

struct P { long r, c; }

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(long[]), h = rd1[0], w = rd1[1];
  auto n = readln.chomp.to!size_t;

  auto p = new P[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.splitter;
    auto r = rd2.front.to!long; rd2.popFront();
    auto c = rd2.front.to!long;
    p[i] = P(r-1, c);
  }

  auto pc = [0L] ~ p.map!"a.c".array.sort().uniq.array ~ [w+1];
  auto npc = pc.length;

  int[long] ap;
  long[] nm;
  auto i = 0;

  foreach (j; 1..npc) {
    auto c = pc[j], s = pc[j] - pc[j-1];
    if (s == 1) {
      ap[c] = i++;
      nm ~= 1;
    } else if (s == 2) {
      ap[c-1] = i++;
      ap[c] = i++;
      nm ~= [1, 1];
    } else {
      i++;
      ap[c-1] = i++;
      ap[c] = i++;
      nm ~= [s-2, 1, 1];
    }
  }

  foreach (ref pi; p)
    pi.c = ap[pi.c];

  nm = nm[0..$-1];
  auto nnm = nm.length;

  if (h == 1) calc1(w, nnm, p, nm);
  else        calc2(w, nnm, p, nm);
}

auto calc1(long w, size_t n, P[] p, long[] nm)
{
  auto u0 = mint(0), u1 = mint(1);
  auto unit1 = [[u1,u0],[u0,u1]];

  auto q0 = [[u1,u1],[u1,u0]];
  auto q1 = [[u1,u1],[u0,u0]];

  auto st = SegmentTree!(Mat, matMul)(n, unit1);
  foreach (i; 0..n-1) st[n-i-1] = repeatedSquare!(Mat, matMul, long)(q0, nm[i], unit1);
  st[0] = q1;

  auto cap = new bool[](n+1);
  cap[n] = true;

  auto update(long c)
  {
    st[n-c-1] = cap[c] || cap[c+1] ? q1 : q0;
  }

  foreach (pi; p) {
    auto c = pi.c;
    cap[c] = !cap[c];
    if (c > 0) update(c-1);
    update(c);
    auto t = st[0..$];
    writeln(t[0][0]);
  }
}

auto calc2(long w, size_t n, P[] p, long[] nm)
{
  auto u0 = mint(0), u1 = mint(1);
  auto unit2 = [[u1,u0,u0,u0,u0],[u0,u1,u0,u0,u0],[u0,u0,u1,u0,u0],[u0,u0,u0,u1,u0],[u0,u0,u0,u0,u1]];
  auto q0 = [[u1,u1,u1,u1,u1],[u1,u1,u0,u0,u0],[u1,u1,u0,u1,u0],[u1,u1,u1,u0,u0],[u1,u1,u0,u0,u0]];

  auto q(int[] i)
  {
    auto q1 = q0.dup;
    foreach (j; i)
      q1[j] = [u0,u0,u0,u0,u0];
    return q1;
  }

  auto st = SegmentTree!(Mat, matMul)(n, unit2);
  foreach (i; 0..n-1) st[n-i-1] = repeatedSquare!(Mat, matMul, long)(q0, nm[i], unit2);
  st[0] = q([2,3,4]);

  auto cap = new bool[][](2, n+1);
  cap[0][n] = cap[1][n] = true;

  auto update(long c)
  {
    int[] j;
    if (cap[0][c] || cap[1][c]) j ~= 1;
    if (cap[0][c] || cap[0][c+1]) j ~= 2;
    if (cap[1][c] || cap[1][c+1]) j ~= 3;
    if (cap[0][c] || cap[1][c] || cap[0][c+1] || cap[1][c+1]) j ~= 4;
    st[n-c-1] = q(j);
  }

  foreach (pi; p) {
    auto r = pi.r, c = pi.c;
    cap[r][c] = !cap[r][c];
    if (c > 0) update(c-1);
    update(c);
    auto t = st[0..$];
    writeln(t[0][0] + t[1][0]);
  }
}

pure T repeatedSquare(T, alias pred = "a * b", U)(T a, U n)
{
  return repeatedSquare(a, n, T(1));
}

pure T repeatedSquare(T, alias pred = "a * b", U)(T a, U n, T init)
{
  import std.functional;
  alias predFun = binaryFun!pred;

  if (n == 0) return init;

  T r = init;
  while (n > 0) {
    if ((n & 1) == 1)
      r = predFun(r, a);
    a = predFun(a, a);
    n >>= 1;
  }

  return r;
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
