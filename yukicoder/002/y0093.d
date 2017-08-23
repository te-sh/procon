import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10 ^^ 9 + 7;
alias FactorRing!(mod, true) mint;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  if (n == 1) {
    writeln(1);
    return;
  }

  auto dp = new mint[][][][](n+1, n+1, 2, 2);
  dp[2][0][0][0] = mint(2);

  foreach (i; 3..n+1)
    foreach (j; 0..i) {
      auto v11 = dp[i-1][j][1][1];
      if (v11 > 0) {
        dp[i][j][1][1] += v11;           // split x-1,x-3
        dp[i][j-1][0][0] += v11;         // split x,x-2
        dp[i][j-1][1][0] += v11 * (j-2); // split other
        dp[i][j+1][1][1] += v11;         // add next x-1
        dp[i][j][1][0] += v11 * (i-j-1);
      }

      auto v01 = dp[i-1][j][0][1];
      if (v01 > 0) {
        dp[i][j-1][0][0] += v01;         // split x,x-2
        dp[i][j-1][1][0] += v01 * (j-1); // split other
        dp[i][j+1][1][1] += v01 * 2;     // add next x-1
        dp[i][j][1][0] += v01 * (i-j-2);
      }

      auto v10 = dp[i-1][j][1][0];
      if (v10 > 0) {
        dp[i][j][0][1] += v10;           // split x-1,x-3
        dp[i][j-1][0][0] += v10 * (j-1); // split other
        dp[i][j+1][0][1] += v10;         // add next x-1
        dp[i][j][0][0] += v10 * (i-j-1);
      }

      auto v00 = dp[i-1][j][0][0];
      if (v00 > 0) {
        if (j > 0) dp[i][j-1][0][0] += v00 * j; // split
        dp[i][j+1][0][1] += v00 * 2;            // add next x-1
        dp[i][j][0][0] += v00 * (i-j-2);
      }
    }

  writeln(dp[n][0][0][0]);
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
