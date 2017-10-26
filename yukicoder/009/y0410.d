import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), px = rd1[0], py = rd1[1];
  auto rd2 = readln.split.to!(int[]), qx = rd2[0], qy = rd2[1];
  writefln("%.1f", ((px-qx).abs + (py-qy).abs).to!real/2);
}
