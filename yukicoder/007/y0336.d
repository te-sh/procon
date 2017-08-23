import std.algorithm, std.conv, std.range, std.stdio, std.string;

const p = 10 ^^ 9 + 7;
alias FactorRing!(p, true) mint;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  if (n < 3) {
    writeln(0);
    return;
  }

  auto dpa = new mint[][](n+1);
  dpa[3] = new mint[4];
  dpa[3][1] = 1; dpa[3][2] = 1;

  auto dpb = new mint[][](n+1);
  dpb[3] = new mint[4];
  dpb[3][2] = 1; dpb[3][3] = 1;

  foreach (i; 4..n+1) {
    dpa[i] = new mint[](i+1);
    foreach_reverse (j; 1..i)
      dpa[i][j] = dpa[i][j+1] + dpb[i-1][j];

    dpb[i] = new mint[](i+1);
    foreach (j; 2..i+1)
      dpb[i][j] = dpb[i][j-1] + dpa[i-1][j-1];
  }

  auto r = mint(0);
  foreach (i; 1..n+1)
    r += dpa[n][i] + dpb[n][i];

  writeln(r);
}

struct FactorRing(int m, bool pos = false)
{
  long v;

  @property int toInt() { return v.to!int; }
  alias toInt this;

  this(T)(T _v) { v = mod(_v); }

  ref FactorRing!(m, pos) opAssign(int _v)
  {
    v = mod(_v);
    return this;
  }

  pure auto mod(long _v) const
  {
    static if (pos) return _v % m;
    else return (_v % m + m) % m;
  }

  pure auto opBinary(string op: "+")(long rhs) const { return FactorRing!(m, pos)(v + rhs); }
  pure auto opBinary(string op: "-")(long rhs) const { return FactorRing!(m, pos)(v - rhs); }
  pure auto opBinary(string op: "*")(long rhs) const { return FactorRing!(m, pos)(v * rhs); }

  pure auto opBinary(string op)(FactorRing!(m, pos) rhs) const
    if (op == "+" || op == "-" || op == "*") { return opBinary!op(rhs.v); }

  auto opOpAssign(string op: "+")(long rhs) { v = mod(v + rhs); }
  auto opOpAssign(string op: "-")(long rhs) { v = mod(v - rhs); }
  auto opOpAssign(string op: "*")(long rhs) { v = mod(v * rhs); }

  auto opOpAssign(string op)(FactorRing!(m, pos) rhs)
    if (op == "+" || op == "-" || op == "*") { return opOpAssign!op(rhs.v); }
}
