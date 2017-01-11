import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto l = readln.chomp.to!size_t;
  auto m = readln.chomp.to!size_t;
  auto n = readln.chomp.to!size_t;

  m += n / 25;
  n = n % 25;

  l += m / 4;
  m = m % 4;

  l = l % 10;

  writeln(l + m + n);
}
