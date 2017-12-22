import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 998_244_353;
alias mint = FactorRing!mod;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto t = new int[](n-1), a = new int[](n-1), b = new int[](n-1);
  foreach (i; 0..n-1) {
    auto rd = readln.splitter;
    t[i] = rd.front.to!int; rd.popFront();
    a[i] = rd.front.to!int; rd.popFront();
    b[i] = rd.front.to!int;
  }

  auto calc(mint x)
  {
    auto v = new mint[](n+1);
    v[0] = 1; v[1] = x;
    foreach (i; 2..n+1) {
      switch (t[i-2]) {
      case 1:
        v[i] = v[a[i-2]] + v[b[i-2]];
        break;
      case 2:
        v[i] = v[b[i-2]] * a[i-2];
        break;
      case 3:
        v[i] = v[a[i-2]] * v[b[i-2]];
        break;
      default:
        assert(0);
      }
    }
    return v[n];
  }

  auto q = readln.chomp.to!int;
  auto x = readln.split.to!(int[]);
  foreach (xi; x) writeln(calc(mint(xi)));
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
