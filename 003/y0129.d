import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bigint;    // BigInt

const auto p = BigInt(10) ^^ 9;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!BigInt;
  auto m = readln.chomp.to!BigInt;

  auto k = (n / 1000) % m;
  auto r1 = iota(m - k + 1, m + 1).fold!((a, b) => a * b)(BigInt(1));
  auto r2 = iota(1, k + 1).fold!((a, b) => a * b)(BigInt(1));

  writeln((r1 / r2) % p);
}
