import std.algorithm, std.conv, std.range, std.stdio, std.string;

// allowable-error: 10 ** -9

const di1 = [2,3,5,7,11,13], e1 = di1.sum.to!real / 6;
const di2 = [4,6,8,9,10,12], e2 = di2.sum.to!real / 6;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), p = rd[0], c = rd[1];
  writefln("%.10f", e1 ^^ p * e2 ^^ c);
}
