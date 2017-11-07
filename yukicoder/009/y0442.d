import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bigint;    // BigInt

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(BigInt[]), a = rd[0], b = rd[1];
  writeln(gcd(a+b, a*b));
}

T gcd(T)(T a, T b)
{
  if (a < b) return gcd(b, a);
  if (a % b == 0) return b;
  return gcd(b, a % b);
}
