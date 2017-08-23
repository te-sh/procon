import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.numeric;   // gcd, fft

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = n.iota.map!(_ => readln.chomp.to!int).array;

  auto g = a.fold!((a, b) => gcd(a, b));

  foreach (r; 1..101)
    if (g * r % 100 == 0) {
      writeln(r);
      return;
    }
}
