import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10 ^^ 9 + 7;
alias mint = FactorRing!mod;

version(unittest) {} else
void main()
{
  auto x = new int[](25);
  foreach (i; 0..5) x[i*5..i*5+5] = readln.split.to!(int[])[];

  auto c = new int[](26);
  c[] = -1;
  foreach (i, xi; x) c[xi] = i.to!int;

  auto isValid(int b, size_t e)
  {
    auto x = e % 5, y = e / 5;
    if (x != 0 && x != 4) {
      auto n1 = b.bitTest(y*5+x-1), n2 = b.bitTest(y*5+x+1);
      if (n1 && !n2 || !n1 && n2) return false;
    }
    if (y != 0 && y != 4) {
      auto n1 = b.bitTest((y-1)*5+x), n2 = b.bitTest((y+1)*5+x);
      if (n1 && !n2 || !n1 && n2) return false;
    }
    return true;
  }

  mint[int] memo;

  mint calc(int b, int i)
  {
    if (i > 25) return mint(1);
    if (b in memo) return memo[b];

    auto r = mint(0);

    auto e = c[i];
    if (e != -1) {
      if (isValid(b, e)) r += calc(b.bitSet(e), i+1);
    } else {
      foreach (j; 0..25) {
        if (b.bitTest(j) || x[j]) continue;
        if (isValid(b, j)) r += calc(b.bitSet(j), i+1);
      }
    }

    return memo[b] = r;
  }

  writeln(calc(0, 1));
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
