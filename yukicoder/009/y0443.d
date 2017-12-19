import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.numeric;   // gcd, fft
import std.bigint;    // BigInt

version(unittest) {} else
void main()
{
  auto n = readln.chomp;
  auto v = new bool[](10);
  foreach (c; n) v[c-'0'] = true;

  if (v.count(true) == 1) {
    writeln(n);
    return;
  }

  auto g = 0;
  foreach (i; 0..9)
    foreach (j; i+1..10)
      if (v[i] && v[j])
        g = g ? gcd(g, 9*(j-i)) : 9*(j-i);

  auto m = BigInt(n);
  foreach_reverse (i; 1..g+1)
    if (g % i == 0 && m % i == 0) {
      writeln(i);
      return;
    }
}
