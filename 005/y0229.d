import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bigint;    // BigInt

alias Fraction!BigInt frac;

version(unittest) {} else
void main()
{
  auto t1 = readln.chomp.to!BigInt;
  auto t2 = readln.chomp.to!BigInt;
  auto t3 = readln.chomp.to!BigInt;

  auto r = frac(BigInt(10L ^^ 12), BigInt(1));
  foreach (i; 0..(1 << 3)) {
    auto f1 = frac(t1 * t2, i.bitTest(0) ? t2 - t1 : t2 + t1);
    auto f2 = frac(t2 * t3, i.bitTest(1) ? t3 - t2 : t3 + t2);
    auto f3 = frac(t3 * t1, i.bitTest(2) ? t3 - t1 : t3 + t1);

    auto s = lcm(f1, f2, f3);
    if (r > s) r = s;
  }
  writefln("%d/%d", r.num, r.den);
}

auto lcm(frac f1, frac f2, frac f3)
{
  auto n1 = f1.num * f2.den * f3.den;
  auto n2 = f2.num * f1.den * f3.den;
  auto n3 = f3.num * f1.den * f2.den;

  auto g1 = gcd(n1, n2);
  auto n4 = n1 / g1 * n2;
  auto g2 = gcd(n3, n4);
  auto n5 = n3 / g2 * n4;

  return frac(n5, f1.den * f2.den * f3.den);
}

struct Fraction(T)
{
  import std.conv, std.math;
  
  T num, den;

  this(T _num, T _den)
  {
    num = _num;
    den = _den;
    reduce();
  }

  void reduce()
  {
    auto g = gcd(num, den);
    num /= g;
    den /= g;
  }

  int opCmp(ref Fraction!T rhs)
  {
    auto n1 = num * rhs.den;
    auto n2 = rhs.num * den;
    return n1 == n2 ? 0 : (n1 < n2 ? -1 : +1);
  }
}

T gcd(T)(T a, T b)
{
  if (a < b) return gcd(b, a);
  auto r = a % b;
  return r ? gcd(b, r) : b;
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
}
 
