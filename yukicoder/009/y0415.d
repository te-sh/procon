import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.numeric;   // gcd, fft

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], d = rd[1];
  writeln(n/gcd(n, d)-1);
}
