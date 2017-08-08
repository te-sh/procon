import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.numeric;   // gcd, fft

const mod = 10 ^^ 9 + 7;
alias FactorRing!mod mint;

version(unittest) {} else
void main()
{
  auto k = readln.chomp.to!int;
  auto c = readln.split.to!(int[]), mc = c.maxElement, sc = c.sum;

  auto fact = new mint[](sc+1), invFact = new mint[](sc+1);
  fact[0] = mint(1);
  foreach (i; 1..sc+1) fact[i] = fact[i-1] * i;
  invFact[sc] = fact[sc].inv;
  foreach_reverse (i; 1..sc) invFact[i] = invFact[i+1] * (i+1);

  auto g = c.fold!((a, b) => gcd(a, b));
  auto d = g.divisors;

  mint[int] r;
  foreach_reverse (di; d) {
    r[sc/di] = fact[sc/di];
    foreach (ci; c) r[sc/di] *= invFact[ci/di];
    foreach_reverse (ei; d) {
      if (ei <= di) break;
      if (ei % di == 0) r[sc/di] -= r[sc/ei];
    }
  }

  auto s = mint(0);
  foreach (gi; r.byKey) s += r[gi] * mint(gi).inv;

  writeln(s);
}

auto divisors(int n)
{
  int[] r;
  foreach (i; 1..n.nsqrt+1) {
    if (n%i == 0) {
      r ~= i;
      if (n/i != i) r ~= n/i;
    }
  }
  r.sort();
  return r;
}

pure T nsqrt(T)(T n)
{
  import std.algorithm, std.conv, std.range, core.bitop;
  if (n <= 1) return n;
  T m = 1 << (n.bsr / 2 + 1);
  return iota(1, m).map!"a * a".assumeSorted!"a <= b".lowerBound(n).length.to!T;
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
