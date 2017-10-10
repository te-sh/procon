import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 1_777_777_777;
alias mint = FactorRing!mod;

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!long, k = rd[1].to!int;

  auto fact = new mint[](k+1);
  fact[0] = 1;
  foreach (i; 1..k+1) fact[i] = fact[i-1] * i;
  auto invFact = new mint[](k+1);
  invFact[k] = fact[k].inv;
  foreach_reverse (i; 1..k+1) invFact[i-1] = invFact[i] * i;

  auto s1 = mint(1);
  foreach (i; 0..k) s1 *= mint(n-i);
  s1 *= invFact[k];

  auto s2 = fact[k];
  foreach (i; 1..k+1)
    s2 -= fact[k] * invFact[i] * invFact[k-i] * fact[k-i] * (i%2 ? 1 : -1);

  writeln(s1*s2);
}

struct FactorRing(int m, bool pos = false)
{
  version(BigEndian) {
    union { long vl; struct { int vi2; int vi; } }
  } else {
    union { long vl; int vi; }
  }

  @property int toInt() { return vi; }
  alias toInt this;

  this(int v) { vi = v; }
  this(int v, bool runMod) { vi = runMod ? mod(v) : v; }
  this(long v) { vi = mod(v); }

  ref FactorRing!(m, pos) opAssign(int v) { vi = v; return this; }

  auto mod(int v) const
  {
    static if (pos) return v % m;
    else if (m < int.max / 2) return (v % m + m) % m;
    else return v >= 0 ? v % m : (v % m + m) % m;
  }

  pure auto mod(long v) const
  {
    static if (pos) return cast(int)(v % m);
    else return cast(int)((v % m + m) % m);
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

  auto inv() const
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
