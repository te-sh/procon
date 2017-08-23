import std.algorithm, std.conv, std.range, std.stdio, std.string;

const p = 10 ^^ 9 + 7;
alias FactorRing!(p, true) mint;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], s = rd[1], k = rd[2];

  s -= k * n * (n - 1) / 2;
  if (s < 0) {
    writeln(0);
    return;
  }

  auto dp = new mint[][](n+1, s+1); dp[0][0] = 1;
  foreach (i; 0..n)
    foreach (j; 0..s+1) {
      dp[i+1][j] = dp[i][j];
      if (j >= n-i)
        dp[i+1][j] += dp[i+1][j-(n-i)];
    }

  writeln(dp[n][s]);
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
