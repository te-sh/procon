import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(real[]), vl = rd[0], vr = rd[1];
  auto d = readln.chomp.to!real;
  auto w = readln.chomp.to!real;
  writefln("%.7f", d*w/(vl+vr));
}
