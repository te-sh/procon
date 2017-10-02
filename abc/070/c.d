import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.numeric;   // gcd, fft

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto t = new long[](n);
  foreach (i; 0..n) t[i] = readln.chomp.to!long;
  writeln(t.reduce!lcm);
}

auto lcm(long a, long b) { return a / gcd(a, b) * b; }
