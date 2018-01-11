import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10^^9+7;
alias mint = FactorRing!mod;

const r = 3;

version(unittest) {} else
void main()
{
  auto stats = makeStats(), ns = stats.length.to!int;

  int[int] mi;
  foreach (int i, stat; stats) mi[stat] = i;

  auto m = Matrix!mint(ns, ns);
  foreach (si; stats)
    foreach (sj; canMoves(si))
      m[mi[sj]][mi[si]] = 1;

  auto n = readln.chomp.to!long;
  auto mp = repeatedSquare!(Matrix!mint)(m, n, Matrix!mint.unit(ns));

  auto ans = mint(0);
  foreach (si; stats)
    if (!(si>>r))
      ans += mp[mi[si]][mi[(1<<r)-1]];

  writeln(ans);
}

auto makeStats()
{
  int[] stats;
  foreach (i; 0..1<<(r*2))
    if (!(iota(r).any!(j => !i.bitTest(j) && i.bitTest(r+j)) || iota(r-1).any!(j => !i.bitTest(j) && !i.bitTest(j+1))))
      stats ~= i;
  return stats;
}

auto canMoves(int prevStat)
{
  auto stat = (prevStat>>r);

  int[] canMoves(int stat, int j)
  {
    if (j == r) return [stat];
    if (stat.bitTest(j)) return canMoves(stat, j+1);
    int[] stats;
    if (prevStat.bitTest(j) && (j == 0 || stat.bitTest(j-1)))
      stats ~= canMoves(stat, j+1);
    stats ~= canMoves(stat.bitSet(j).bitSet(r+j), j+1);
    if (j < r-1 && !stat.bitTest(j+1))
      stats ~= canMoves(stat.bitSet(j).bitSet(j+1), j+2);
    return stats;
  }

  return canMoves(stat, 0);
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

pure T repeatedSquare(T, alias pred = "a * b", U)(T a, U n)
{
  return repeatedSquare(a, n, T(1));
}

pure T repeatedSquare(T, alias pred = "a * b", U)(T a, U n, T init)
{
  import std.functional;
  alias predFun = binaryFun!pred;

  if (n == 0) return init;

  auto r = init;
  while (n > 0) {
    if ((n & 1) == 1)
      r = predFun(r, a);
    a = predFun(a, a);
    n >>= 1;
  }

  return r;
}

struct Matrix(T)
{
  size_t r, c;
  T[][] a;

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

  ref T[] opIndex(size_t i) { return a[i]; }

  ref auto opBinary(string op)(ref Matrix!T b) if (op == "+" || op == "-") in { assert(r == b.r && c == b.c); } body
  {
    auto x = Matrix!T(r, c);
    foreach (i; 0..r) foreach (j; 0..c) x[i][j] = mixin("a[i][j]"~op~"b[i][j]");
    return x;
  }

  ref auto opBinary(string op: "*")(ref Matrix!T b) in { assert(c == b.r); } body
  {
    auto x = Matrix!T(r, b.c);
    foreach (i; 0..r) foreach (j; 0..b.c) foreach (k; 0..c) x[i][j] += a[i][k]*b[k][j];
    return x;
  }
}

struct FactorRing(int m, bool pos = false)
{
  version(BigEndian) union { long vl; struct { int vi2; int vi; } } else union { long vl; int vi; }
  static init() { return FactorRing!(m, pos)(0); }

  @property int toInt() { return vi; }
  alias toInt this;

  this(int v) { vi = v; }
  this(int v, bool runMod) { vi = runMod ? mod(v) : v; }
  this(long v) { vi = mod(v); }

  ref auto opAssign(int v) { vi = v; return this; }

  pure auto mod(int v) const { static if (pos) return v%m; else return (v%m+m)%m; }
  pure auto mod(long v) const { static if (pos) return cast(int)(v%m); else return cast(int)((v%m+m)%m); }

  static if (!pos) pure auto opUnary(string op: "-")() { return FactorRing!(m, pos)(mod(-vi)); }

  static if (m < int.max / 2) {
    pure auto opBinary(string op)(int r) if (op == "+" || op == "-") { return FactorRing!(m, pos)(mod(mixin("vi"~op~"r"))); }
    ref auto opOpAssign(string op)(int r) if (op == "+" || op == "-") { vi = mod(mixin("vi"~op~"r")); return this; }
  } else {
    pure auto opBinary(string op)(int r) if (op == "+" || op == "-") { return FactorRing!(m, pos)(mod(mixin("vl"~op~"r"))); }
    ref auto opOpAssign(string op)(int r) if (op == "+" || op == "-") { vi = mod(mixin("vl"~op~"r")); return this; }
  }
  pure auto opBinary(string op: "*")(int r) { return FactorRing!(m, pos)(mod(vl*r)); }
  ref auto opOpAssign(string op: "*")(int r) { vi = mod(vl*r); return this; }

  pure auto opBinary(string op)(FactorRing!(m, pos) r) if (op == "+" || op == "-" || op == "*") { return opBinary!op(r.vi); }
  ref auto opOpAssign(string op)(FactorRing!(m, pos) r) if (op == "+" || op == "-" || op == "*") { return opOpAssign!op(r.vi); }
}
