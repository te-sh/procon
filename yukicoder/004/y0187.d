import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags
import std.bigint;    // BigInt

const p = 10^^9 + 7;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto xi = new BigInt[](n), yi = new BigInt[](n);
  foreach (ref x, ref y; lockstep(xi, yi)) {
    auto rd = readln.split.to!(BigInt[]);
    x = rd[0]; y = rd[1];
  }

  auto z = xi[0], l = yi[0];

  foreach (i; 1..n) {
    auto r = calc(z, l, xi[i], yi[i]); z = r[0]; l = r[1];
    if (l == -1) {
      writeln(-1);
      return;
    }
  }

  writeln((z == 0 ? l : z) % p);
}

auto calc(T)(T x1, T y1, T x2, T y2)
{
  auto g = euclid(y1, y2);
  if (x1 % g != x2 % g) return Tuple!(T, T)(BigInt(-1), BigInt(-1));

  T m, n;
  exEuclid(y1, y2, m, n);
  m *= (x2 - x1) / g;

  auto l = y1 / g * y2;

  return Tuple!(T, T)(((m * y1 + x1) % l + l) % l, l);
}

pure T euclid(T)(T a, T b)
{
  if (a < b) return euclid(b, a);
  auto c = a % b;
  return c == 0 ? b : euclid(b, c);
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
