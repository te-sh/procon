import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], k = rd[1];

  auto calc() {
    foreach (i; 2..n.to!real.sqrt.to!int + 2)
      if (n % i == 0) return n / i;
    return 1;
  }

  writeln(calc);
}
