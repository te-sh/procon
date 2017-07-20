import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bigint;    // BigInt

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(BigInt[]), a = rd[0], b = rd[1], c = rd[2], d = rd[3];
  writeln(a * b * c % d);
}
