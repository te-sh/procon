import std.algorithm, std.conv, std.range, std.stdio, std.string;

// allowable-error: 10 ** -12

const di1 = [2,3,5,7,11,13];
const di2 = [4,6,8,9,10,12];

version(unittest) {} else
void main()
{
  auto k = readln.chomp.to!int;
  auto c = di1.map!(d1 => di2.count!(d2 => d1 * d2 == k)).sum;
  writefln("%.13f", c.to!real / 36);
}
