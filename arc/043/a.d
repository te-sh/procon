import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], a = rd[1], b = rd[2];
  auto s = new long[](n);
  foreach (i; 0..n) s[i] = readln.chomp.to!long;

  auto sma = s.reduce!max, smi = s.reduce!min;
  if (sma == smi) {
    writeln(-1);
    return;
  }

  auto p = b.to!real / (sma - smi);
  auto q = a - p / n * s.sum;

  writefln("%.7f %.7f", p, q);
}
