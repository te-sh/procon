import std.algorithm, std.conv, std.range, std.stdio, std.string;

// allowable-error: 0.01

version(unittest) {} else
void main()
{
  auto k = readln.chomp.to!size_t;

  auto ei = new real[](k);
  ei[] = 0;

  foreach_reverse (i; k.iota) {
    foreach (j; 1..7)
      if (i + j < k) ei[i] += ei[i + j] / 6;
    ei[i] += 1;
  }

  writefln("%.3f", ei[0]);
}
