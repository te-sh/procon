import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

const mod = 10^^9+7;
alias mint = FactorRing!mod;

version(unittest) {} else
void main()
{
  auto z = 3001;

  auto rd1 = readln.split.to!(int[]), n = rd1[0], k = rd1[1];

  auto b = new int[][](z, z), sb = new int[][](z, z);

  foreach (i; 0..n) {
    auto rd2 = readln.splitter;
    auto x = rd2.front.to!int; rd2.popFront();
    auto y = rd2.front.to!int;
    ++b[y][x];
  }

  foreach (y; 0..z)
    foreach (x; 0..z) {
      sb[y][x] = b[y][x];
      if (y > 0) sb[y][x] += sb[y-1][x];
      if (x > 0) sb[y][x] += sb[y][x-1];
      if (x > 0 && y > 0) sb[y][x] -= sb[y-1][x-1];
    }

  auto monsters(int x0, int y0, int x1, int y1)
  {
    x1 = min(x1, z-1);
    y1 = min(y1, z-1);

    auto s = sb[y1][x1];
    if (y0 > 0) s -= sb[y0-1][x1];
    if (x0 > 0) s -= sb[y1][x0-1];
    if (y0 > 0 && x0 > 0) s += sb[y0-1][x0-1];

    return s;
  }

  auto calc(int w)
  {
    foreach (y; 0..z-w) 
      foreach (x; 0..z-w) {
        auto s = monsters(x, y, x+w, y+w);
        if (s >= k) return true;
      }
    return false;
  }

  auto bsearch = iota(0, z).map!(w => tuple(w, calc(w))).assumeSorted!"a[1] < b[1]";
  auto w = bsearch.upperBound(tuple(0, false)).front[0];

  writeln(w);

  auto fact = new mint[](n+1), invFact = new mint[](n+1);
  fact[0] = 1;
  foreach (i; 1..n+1) fact[i] = fact[i-1] * i;
  invFact[n] = fact[n].inv;
  foreach_reverse (i; 1..n+1) invFact[i-1] = invFact[i] * i;

  auto nCr(int n, int r)
  {
    if (r < 0 || r > n) return mint(0);
    return fact[n] * invFact[n-r] * invFact[r];
  }

  auto ans = mint(0);
  foreach (y; 0..z)
    foreach (x; 0..z) {
      auto s = monsters(x, y, x+w, y+w);

      auto bi = b[y][x];
      if (bi) {
        ans += nCr(s, k) - nCr(s-bi, k);
      }

      auto sl = monsters(x, y, x, y+w)-bi;
      auto st = monsters(x, y, x+w, y)-bi;
      if (sl && st) {
        ans += nCr(s-bi, k) - nCr(s-bi-sl, k) - nCr(s-bi-st, k) + nCr(s-bi-(sl+st), k);
        continue;
      }
    }

  writeln(ans);
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

  pure auto opBinary(string op: "/")(FactorRing!(m, pos) rhs) { return FactorRing!(m, pos)(mod(vl * rhs.inv.vi)); }
  pure auto opBinary(string op: "/")(int rhs) { return opBinary!op(FactorRing!(m, pos)(rhs)); }
  auto opOpAssign(string op: "/")(FactorRing!(m, pos) rhs) { vi = mod(vl * rhs.inv.vi); }
  auto opOpAssign(string op: "/")(int rhs) { return opOpAssign!op(FactorRing!(m, pos)(rhs)); }

  pure auto inv() const
  {
    int x = vi, a, b;
    exEuclid(x, m, a, b);
    return FactorRing!(m, pos)(mod(a));
  }
}

pure T exEuclid(T)(T a, T b, ref T x, ref T y)
{
  auto g = a;
  x = 1;
  y = 0;
  if (b != 0) {
    g = exEuclid(b, a % b, y, x);
    y -= a / b * x;
  }
  return g;
}
