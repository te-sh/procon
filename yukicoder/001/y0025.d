import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bigint;    // BigInt
import std.numeric;   // gcd

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;
  auto m = readln.chomp.to!long;

  auto g = gcd(n, m);
  n /= g;
  m /= g;

  writeln(calc(n.to!BigInt, m.to!BigInt));
}

auto calc(T)(T n, T m)
{
  if (n % m == 0)
    return dsr(n / m);

  auto f1 = powers(m, 2);
  auto f2 = powers(m, 5);

  if (m != 2.to!T ^^ f1 * 5.to!T ^^ f2)
    return -1;

  auto k = n.to!BigInt;
  if (f1 < f2) k *= 2.to!T ^^ (f2 - f1);
  if (f1 > f2) k *= 5.to!T ^^ (f1 - f2);
  return dsr(k);
}

auto powers(T)(T n, int d)
{
  auto c = 0;
  for (; n % d == 0; n /= d) ++c;
  return c;
}

auto dsr(T)(T n)
{
  while (n % 10 == 0) n /= 10;
  return (n % 10).to!int;
}
