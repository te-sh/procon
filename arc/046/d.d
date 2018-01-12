import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.numeric;   // gcd, fft

const mod = 10^^9+7;
alias mint = FactorRing!mod;
void read2(S,T)(ref S a,ref T b){auto r=readln.splitter;a=r.front.to!S;r.popFront;b=r.front.to!T;}

version(unittest) {} else
void main()
{
  long h, w; read2(h, w);
  auto g = gcd(h, w);

  auto fact = new mint[](g+1);
  fact[0] = 1;
  foreach (i; 1..g+1) fact[i] = fact[i-1]*i.to!int;
  auto invFact = new mint[](g+1);
  invFact[g] = fact[g].inv;
  foreach_reverse (i; 1..g+1) invFact[i-1] = invFact[i]*i.to!int;

  auto ans = mint(0);
  foreach (y; 0..g+1) {
    auto x = g-y;
    if (y >= h || x >= w) continue;

    auto ly = y > 0 ? h/gcd(h, y) : 1;
    auto lx = x > 0 ? w/gcd(w, x) : 1;
    if (h*w/g == ly*lx/gcd(ly, lx))
      ans += fact[g] * invFact[y] * invFact[x];
  }

  writeln(ans);
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

  pure auto opBinary(string op: "/")(FactorRing!(m, pos) r) { return FactorRing!(m, pos)(mod(vl * r.inv.vi)); }
  pure auto opBinary(string op: "/")(int r) { return opBinary!op(FactorRing!(m, pos)(r)); }
  ref auto opOpAssign(string op: "/")(FactorRing!(m, pos) r) { vi = mod(vl * r.inv.vi); return this; }
  ref auto opOpAssign(string op: "/")(int r) { return opOpAssign!op(FactorRing!(m, pos)(r)); }

  pure auto inv()
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
