import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto t = new real[](n);
  foreach (i; 0..n) {
    auto rd = readln.split.to!(int[]);
    t[i] = rd[0..4].sum + rd[4].to!real * 110 / 900;
  }
  writefln("%.5f", t.reduce!max);
}
