import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags
import std.bigint;    // BigInt

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto k = readln.chomp.to!size_t;
  auto bi = k.iota.map!(_ => readln.split.to!(size_t[]).front - 1).array;

  auto ci = n.iota.array;
  foreach (b; bi)
    swap(ci[b], ci[b+1]);

  auto di = n.iota.map!(i => ci.countUntil(i));

  auto ei = new size_t[][](n);
  foreach (i, ref e; ei) {
    for (auto j = i; e.empty || j != i; j = di[j])
      e ~= j;
  }

  auto yi = ei.map!(e => e.length.to!BigInt).array;

  auto q = readln.chomp.to!size_t;
  foreach (_; 0..q) {
    auto ai = readln.split.to!(size_t[]).map!"a - 1".array;
    auto fi = n.iota.map!(i => ai.countUntil(i));
    auto xi = zip(ei, fi).map!(ef => ef[0].countUntil(ef[1]).to!BigInt).array;
    if (xi.any!"a == -1")
      writeln(-1);
    else
      writeln(calc1(xi, yi));
  }
}

auto calc1(T)(T[] xi, T[] yi)
{
  auto z = xi[0], l = yi[0];

  foreach (i; 1..xi.length) {
    auto r = calc2(z, l, xi[i], yi[i]); z = r[0]; l = r[1];
    if (l == -1)
      return T(-1);
  }

  return z == 0 ? l : z;
}

auto calc2(T)(T x1, T y1, T x2, T y2)
{
  auto g = euclid(y1, y2);
  if (x1 % g != x2 % g) return Tuple!(T, T)(T(-1), T(-1));

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
