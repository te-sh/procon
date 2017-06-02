import std.algorithm, std.conv, std.range, std.stdio, std.string;

const p = 10 ^^ 9 + 7;
alias FactorRing!(p, true) pint;
alias FactorRing!p mint;

version(unittest) {} else
void main()
{
  auto rd = readln.split.map!(s => s.map!(c => (c - '0').to!int).array), a = rd[0], b = rd[1];

  auto r = mint(calc!true(b)) - mint(calc!false(a));

  writeln(r);
}

auto calc(bool includeMax)(int[] ai)
{
  auto n = ai.length;

  auto dp = new pint[][][][][](n+1, 2, 2, 3, 8);
  dp[0][0][0][0][0] = 1;

  foreach (i; 0..n)
    foreach (j; 0..2)
      foreach (k; 0..2)
        foreach (l; 0..3)
          foreach (m; 0..8) {
            int lim = j ? 9 : ai[i];
            foreach (d; 0..lim+1)
              dp[i+1][j || d < lim][k || d == 3][(l + d) % 3][(m * 10 + d) % 8] += dp[i][j][k][l][m];
          }

  auto r = pint(0);

  auto jMin = includeMax ? 0 : 1;
  foreach (j; jMin..2)
    foreach (k; 0..2)
      foreach (l; 0..3)
        foreach (m; 1..8)
          if (k == 1 || l == 0)
            r += dp[$-1][j][k][l][m];

  return r;
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
