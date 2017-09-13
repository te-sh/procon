import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.numeric;   // gcd, fft

version(unittest) {} else
void main()
{
  auto a = readln.chomp.to!int;
  auto b = readln.chomp.to!int;
  auto n = readln.chomp.to!int;
  auto l = a * b / gcd(a, b);
  writeln((n + l - 1) / l * l);
}
