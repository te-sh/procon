import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.numeric;   // gcd

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), m = rd[0], n = rd[1];

  auto g = gcd(m, n);
  m /= g;
  n /= g;

  auto r = 0;
  while (m > 1 || n > 1) {
    if (m > n) {
      r += (m - 1) / n;
      m = (m - 1) % n + 1;
    } else {
      swap(m, n);
      ++r;
    }
  }

  writeln(r);
}
