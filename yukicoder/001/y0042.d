import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10 ^^ 9 + 9;
alias FactorRing!mod mint;

const c = [1, 5, 10, 50, 100, 500], nc = c.length, dpm = 3500;
const dp = calcDp();

version(unittest) {} else
void main()
{
  auto t = readln.chomp.to!size_t;
  foreach (_; 0..t) {
    auto m = readln.chomp.to!long;
    writeln(calc(m));
  }
}

auto calc(long m)
{
  if (m <= dpm) return dp[m];

  auto md = mint(m / 500), mm = m % 500;

  auto r = mint(0);
  foreach (i; 0..nc+1) {
    auto s = mint(dp[mm + i * 500]);
    foreach (j; 0..nc+1)
      if (i != j) {
        s *= md - j;
        s *= mint(i - j).inv;
      }
    r += s;
  }

  return r;
}

auto calcDp()
{
  auto dp1 = new int[](dpm+1), dp2 = new int[](dpm+1);
  dp1[] = 1;
  foreach (k; 1..nc) {
    dp2[] = dp1[];
    foreach (i; c[k]..dpm+1)
      dp2[i] += dp2[i-c[k]];
    dp1[] = dp2[];
  }
  return dp1;
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

  pure auto inv() const
  {
    int x = v.to!int, a, b;
    exEuclid(x, m, a, b);
    return FactorRing!(m, pos)(a);
  }
}

pure T exEuclid(T)(T a, T b, ref T x, ref T y)
{
  auto g = a;
  x = 1;
  y = 0;
  if (b != 0) {
    g = exEuclid(b, a % b, y, x);
    y -= a / b * x;
  }
  return g;
}
