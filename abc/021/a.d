import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto r = n.bitsSet.map!"2^^a";
  writeln(r.length);
  foreach (ri; r) writeln(ri);
}
