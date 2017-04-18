import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags
import std.numeric;   // gcd
import std.bigint;    // BigInt

version(unittest) {} else
void main()
{
  auto n = 3;
  auto xi = new BigInt[](n), yi = new BigInt[](n);
  foreach (ref x, ref y; lockstep(xi, yi)) {
    auto rd = readln.split.to!(BigInt[]);
    x = rd[0]; y = rd[1];
  }

  auto r1 = calc(xi[0], yi[0], xi[1], yi[1]), z1 = r1[0], l1 = r1[1];
  if (l1 == -1) {
    writeln(-1);
    return;
  }

  auto r2 = calc(z1, l1, xi[2], yi[2]), z2 = r2[0], l2 = r2[1];
  if (l2 == -1) {
    writeln(-1);
    return;
  }

  writeln(z2 == 0 ? l2 : z2);
}

auto calc(T)(T x1, T y1, T x2, T y2)
{
  auto g = gcd(y1.to!long, y2.to!long);
  if (x1 % g != x2 % g) return Tuple!(T, T)(BigInt(-1), BigInt(-1));

  T m, n;
  exEuclid(y1, y2, m, n);
  m *= (x2 - x1) / g;

  auto l = y1 / g * y2;

  return Tuple!(T, T)(((m * y1 + x1) % l + l) % l, l);
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
