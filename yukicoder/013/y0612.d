import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

const mod = 10^^9+7;
alias mint = FactorRing!(mod, true);

version(unittest) {} else
void main()
{
  auto t = readln.chomp.to!int;
  auto rd = readln.split.to!(int[]);
  auto a = rd[0].abs, b = rd[1].abs, c = rd[2].abs, d = rd[3], e = rd[4];

  auto m = max(a, b, c) * t;
  auto dp = new mint[][](t+1, m*2+1);
  dp[0][m] = 1;

  foreach (i; 0..t)
    foreach (j; -m..m+1) {
      if (j+a <=  m) dp[i+1][j+m] += dp[i][j+a+m];
      if (j-a >= -m) dp[i+1][j+m] += dp[i][j-a+m];
      if (j+b <=  m) dp[i+1][j+m] += dp[i][j+b+m];
      if (j-b >= -m) dp[i+1][j+m] += dp[i][j-b+m];
      if (j+c <=  m) dp[i+1][j+m] += dp[i][j+c+m];
      if (j-c >= -m) dp[i+1][j+m] += dp[i][j-c+m];
    }

  auto ans = mint(0);
  foreach (j; d..e+1)
    if (j >= -m && j <= m) ans += dp[t][j+m];

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
}
