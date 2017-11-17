import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10^^9+7;
alias mint = FactorRing!mod;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto a = readln.split.to!(int[]);
  auto t = readln.chomp.to!int;

  if (t <= n) {
    writeln(a[t]);
    return;
  }

  auto prod = mint(t);
  foreach (i; 1..n+1) prod *= mint(t)-mint(i);

  auto fact = new mint[](n+1);
  fact[0] = 1;
  foreach (i; 1..n+1) fact[i] = fact[i-1] * i;
  auto invFact = new mint[](n+1);
  invFact[n] = fact[n].inv;
  foreach_reverse (i; 1..n+1) invFact[i-1] = invFact[i] * i;

  auto ans = mint(0);
  foreach (i; 0..n+1) {
    auto r = prod / (mint(t)-mint(i));
    if (i > 0) r *= invFact[i];
    if (i < n) r *= invFact[n-i];
    if ((n-i)%2) r *= -1;
    ans += mint(a[i])*r;
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
