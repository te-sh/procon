import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.numeric;   // gcd, fft

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;
  auto rd = readln.split.to!(long[]), a = rd[0], b = rd[1], c = rd[2];

  auto ab = a / gcd(a, b) * b, bc = b / gcd(b, c) * c, ca = c / gcd(c, a) * a;
  auto abc = ab / gcd(ab, bc) * bc;

  auto r = n/a + n/b + n/c - (n/ab + n/bc + n/ca) + n/abc;
  writeln(r);
}
