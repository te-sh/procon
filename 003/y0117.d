import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.regex;     // RegEx

const int p = 10 ^^ 9 + 7;
alias FactorRing!p mint;

version(unittest) {} else
void main()
{
  auto bufFrac = new mint[](2_000_000), sf = 1;
  bufFrac[0] = 1;

  auto frac(int n) {
    if (sf <= n) {
      foreach (i; sf..n+1)
        bufFrac[i] = bufFrac[i - 1] * i;
      sf = n + 1;
    }
    return bufFrac[n];
  }

  auto t = readln.chomp.to!size_t;
  foreach (_; t.iota) {
    auto rd = readln.chomp;
    auto m = rd.matchFirst(r"([CPH])\((\d+),(\d+)\)");
    auto n = m[2].to!int, k = m[3].to!int;

    auto r = mint(0);
    switch (m[1]) {
    case "C":
      if (n >= k)
        r = frac(n) * frac(k).inv * frac(n - k).inv;
      break;
    case "P":
      if (n >= k)
        r = frac(n) * frac(n - k).inv;
      break;
    case "H":
      if (n > 0)
        r = frac(n + k - 1) * frac(k).inv * frac(n - 1).inv;
      else if (k == 0)
        r = 1;
      break;
    default:
      assert(0);
    }

    writeln(r);
  }
}

struct FactorRing(int m) {
  long v;

  @property int toInt() { return v.to!int; }
  alias toInt this;

  this(T)(T _v) { v = mod(_v); }

  ref FactorRing!m opAssign(int _v) {
    v = mod(_v);
    return this;
  }

  auto mod(long _v) {
    if (_v > 0) return _v % m;
    else return ((_v % m) + m) % m;
  }

  auto opBinary(string op: "+")(FactorRing!m rhs) { return FactorRing!m(v + rhs.v); }
  auto opBinary(string op: "-")(FactorRing!m rhs) { return FactorRing!m(v - rhs.v); }
  auto opBinary(string op: "*")(FactorRing!m rhs) { return FactorRing!m(v * rhs.v); }
  auto opBinary(string op: "^^")(FactorRing!m rhs) { return pow(this, rhs.toInt); }

  auto opBinary(string op)(int rhs)
    if (op == "+" || op == "-" || op == "*") { return opBinary!op(FactorRing!m(rhs)); }
  auto opBinary(string op: "^^")(int rhs) { return pow(this, rhs); }

  auto pow(FactorRing!m a, int b) {
    if (b == 0) return FactorRing!m(1);
    if (a == 0) return FactorRing!m(0);
    auto c = FactorRing!m(1);
    for (; b > 0; a = a * a, b >>= 1)
      if ((b & 1) == 1) c = c * a;
    return c;
  }

  auto inv() {
    int x = v.to!int, a, b;
    exEuclid(x, m, a, b);
    return FactorRing!m(a);
  }
}

T exEuclid(T)(T a, T b, ref T x, ref T y)
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
