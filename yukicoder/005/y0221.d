import std.algorithm, std.conv, std.range, std.stdio, std.string;

// allowable-error: 0.01

const real acc = 0.99;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!real / 10000;

  auto pca = (1 - n) * (1 - acc);
  auto pa = pca + n * acc;

  writefln("%.3f", pca / pa * 100);
}
