import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10 ^^ 9 + 7;
alias FactorRing!mod mint;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto c = new int[](n);
  foreach (_; 0..n) ++c[readln.chomp.to!int];

  auto fact = new mint[](n+1); fact[0] = 1;
  foreach (i; 1..n+1) fact[i] = fact[i-1] * i;

  auto dp1 = new mint[](n+1), dp2 = new mint[](n+1);

  foreach (i; 1..n+1) {
    dp2[] = mint(0);
    dp2[1] = dp1[1] + c[i-1];
    foreach (j; 2..i+1)
      dp2[j] = dp1[j] + mint(c[i-1]) * dp1[j-1];
    dp1[] = dp2[];
  }

  auto r = mint(0);
  foreach (i; 1..n+1)
    r += dp1[i] * fact[n-i] * (-1)^^(i-1);

  writeln(fact[n] - r);
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
