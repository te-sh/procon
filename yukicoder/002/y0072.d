import std.algorithm, std.conv, std.range, std.stdio, std.string;

const long mod = 10 ^^ 6 + 7;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;

  auto m1 = n / 2 + 1;
  auto m2 = n - n / 2 + 1;
  auto r = ((m1 % mod) * (m2 % mod) - 1 + mod) % mod;

  writeln(r);
}
