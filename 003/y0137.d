import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 1234567891;
alias FactorRing!(mod, true) mint;

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!size_t, m = rd[1].to!long;
  auto a = readln.split.to!(int[]), sa = a.sum;

  auto dp1 = new mint[](sa*2+2), dp2 = new mint[](sa*2+2);
  dp1[0] = mint(1);

  for (; m > 0; m /= 2) {
    foreach (i; 0..n) {
      dp2[] = dp1[];
      dp1[a[i]..$] += dp2[0..$-a[i]];
    }

    foreach (j; 0..sa+1) dp1[j] = dp1[j*2+m%2];
    dp1[sa+1..$] = mint(0);
  }

  writeln(dp1[0]);
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
