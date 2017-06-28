import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;

  auto a = 1, b = 26L;
  while (n > 0) {
    if (n < b) break;
    ++a;
    n -= b;
    b *= 26;
  }

  auto r = new int[](a);
  foreach_reverse (i; 0..a) {
    r[i] = n % 26;
    n /= 26;
  }

  foreach (ri; r) write(('A' + ri).to!char);
  writeln;
}
