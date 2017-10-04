import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.numeric;   // gcd, fft

version(unittest) {} else
void main()
{
  auto rd = readln.chomp.split('/').to!(long[]), x = rd[0], y = rd[1];

  auto g = gcd(x, y); x /= g; y /= g;

  auto mi = x*2 / y^^2 - 1, ma = (x*2 + y^^2 - 1) / y^^2 + 1, found = false;
  foreach (k; max(0, mi)..ma+1) {
    auto n = k * y;
    auto m = n*(n+1)/2 - k*x;
    if (m > 0 && m <= n) {
      writeln(n, " ", m);
      found = true;
    }
  }
  if (!found) writeln("Impossible");
}
