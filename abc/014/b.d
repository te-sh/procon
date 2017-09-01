import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], x = rd[1];
  auto a = readln.split.to!(int[]);
  writeln(a.indexed(x.bitsSet).sum);
}
