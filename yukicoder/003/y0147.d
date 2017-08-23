import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bigint;    // BigInt

const auto p = 10^^9 + 7;
alias FactorRing!p mint;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto r = mint(1);
  foreach (_; n.iota) {
    auto rd = readln.split, c = rd[0].to!long, d = rd[1].to!BigInt;
    auto e = fibonacchi!(mint, long)(c + 2);
    auto f = (d % (p - 1)).to!int;
    r = r * (e == 0 ? mint(0) : e ^^ f);
  }

  writeln(r);
}

auto fibonacchi(T, U)(U n)
{
  static T[4][U.sizeof * 8] buf;
  buf[0] = [T(1), T(1), T(1), T(0)];
  static sf = 0;

  T[4] matProd(T)(T[4] a, T[4] b) {
    return [a[0] * b[0] + a[1] * b[2],
            a[0] * b[1] + a[1] * b[3],
            a[2] * b[0] + a[3] * b[2],
            a[2] * b[1] + a[3] * b[3]];
  }

  auto b = 0;
  T[4] r = [T(1), T(0), T(0), T(1)];
  for (; n > 0; ++b, n >>= 1) {
    if ((n & U(1)) != 0) {
      while (b > sf) {
        buf[sf + 1] = matProd(buf[sf], buf[sf]);
        ++sf;
      }
      r = matProd(r, buf[b]);
    }
  }

  return r[1];
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

  auto mod(long _v) { return _v > 0 ? _v % m : ((_v % m) + m) % m; }

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
}
