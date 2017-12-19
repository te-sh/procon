import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

alias mint = FactorRing!9;

version(unittest) {} else
void main()
{
  auto t = readln.chomp.to!int;

  auto f3 = new int[](16);
  f3[0] = 1;
  foreach (i; 1..16) f3[i] = f3[i-1]*3;

  auto f3m = new mint[](16);
  foreach (i; 0..16) f3m[i] = mint(f3[i], true);

  auto split3(int i)
  {
    auto j = 0;
    while (i > 0 && i%3 == 0) {
      ++j;
      i /= 3;
    }
    return tuple(j, mint(i, true));
  }

  foreach (_; 0..t) {
    auto rd = readln.splitter;
    auto n = rd.front.to!int; rd.popFront();
    auto x = rd.front.to!int; rd.popFront();
    auto a = rd.front.to!int; rd.popFront();
    auto b = rd.front.to!int; rd.popFront();
    auto m = rd.front.to!int;

    auto ans = mint(0), s = 0;
    auto r = x;
    auto c3 = 0, co = mint(1);

    foreach (i; 0..n) {
      ans += mint(r%10, true) * f3m[c3] * co;
      s += r%10;

      auto r1 = split3(n-i-1), r2 = split3(i+1);
      c3 += r1[0] - r2[0];
      co *= r1[1] / r2[1];

      r = ((r ^ a) + b) % m;
    }

    if (s == 0)
      writeln(0);
    else
      writeln(ans == 0 ? 9 : ans);
  }
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
