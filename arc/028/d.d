import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10^^9+7;
alias mint = FactorRing!mod;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), n = rd1[0], m = rd1[1], q = rd1[2];
  auto a = readln.split.to!(int[]);

  auto c = new int[](n), s = a.sum;
  foreach (i; 0..n) c[i] = s - a[i];

  auto dp1 = new mint[](m+1), dp2 = new mint[](m+1), dps = new mint[](m+1);
  dp1[0] = 1;
  foreach (i; 0..n) {
    dps[0] = dp1[0];
    foreach (j; 1..m+1) dps[j] = dps[j-1] + dp1[j];

    foreach (j; 0..m+1) {
      dp2[j] = dps[j];
      if (j-a[i] >= 1) dp2[j] -= dps[j-a[i]-1];
    }

    dp1[] = dp2[];
  }

  auto dp4 = new mint[][](n, m+1);
  foreach (i; 0..n) {
    dp4[i][0] = dps[0] = 1;
    foreach (j; 1..m+1) {
      if (j > c[i]) break;
      dp4[i][j] = dps[j] = dp1[j];
      dp4[i][j] -= dps[j-1];
      if (j-a[i] >= 1) dp4[i][j] += dps[j-a[i]-1];
      dps[j] = dps[j-1] + dp4[i][j];
    }
  }

  foreach (_; 0..q) {
    auto rd2 = readln.splitter;
    auto k = rd2.front.to!int-1; rd2.popFront();
    auto x = rd2.front.to!int;
    writeln(dp4[k][m-x]);
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
}
