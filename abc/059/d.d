import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

// path: arc072_b

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), x = rd[0], y = rd[1];
  writeln((x-y).abs <= 1 ? "Brown" : "Alice");
}
