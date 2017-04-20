import std.algorithm, std.conv, std.range, std.stdio, std.string;

const p = 1000000009;
alias FactorRing!p mint;

version(unittest) {} else
void main()
{
  auto rd = readln.split.map!(s => s.map!(c => c.to!string.to!int).array), m = rd[0], d = rd[1];

  auto maxD = max(m.length, d.length);
  auto maxK = maxD * 9 + 1;

  auto dp9 = new mint[][](maxD + 1, maxK);
  dp9[0][0] = mint(1);

  foreach (i; 1..maxD+1)
    foreach (j; 0..10)
      foreach (k; j..maxK)
        dp9[i][k] = dp9[i][k] + dp9[i - 1][k - j];

  auto calc(int[] ni) {
    auto dp = new mint[](maxK);
    auto s = 0;

    foreach (i, n; ni) {
      foreach (j; 0..n) {
        foreach (k; j+s..maxK)
          dp[k] = dp[k] + dp9[ni.length - i - 1][k - j - s];
      }
      s += n;
    }
    dp[s] = dp[s] + 1;

    return dp;
  }

  auto dpm = calc(m), dpd = calc(d);
  writeln(zip(dpm, dpd).map!"a[0] * a[1]".fold!"a + b" - 1);
}

struct FactorRing(int m)
{
  long v;

  @property int toInt() { return v.to!int; }
  alias toInt this;

  this(T)(T _v) { v = mod(_v); }

  ref FactorRing!m opAssign(int _v)
  {
    v = mod(_v);
    return this;
  }

  pure auto mod(long _v) const { return _v > 0 ? _v % m : ((_v % m) + m) % m; }

  pure auto opBinary(string op: "+")(FactorRing!m rhs) const { return FactorRing!m(v + rhs.v); }
  pure auto opBinary(string op: "-")(FactorRing!m rhs) const { return FactorRing!m(v - rhs.v); }
  pure auto opBinary(string op: "*")(FactorRing!m rhs) const { return FactorRing!m(v * rhs.v); }

  pure auto opBinary(string op)(int rhs) const
    if (op == "+" || op == "-" || op == "*") { return opBinary!op(FactorRing!m(rhs)); }
}
