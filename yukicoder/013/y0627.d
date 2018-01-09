import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto p = 0;
  foreach (_; 0..n) {
    auto q = readln.chomp.to!int;
    if ((p-q).abs != 1) {
      writeln("F");
      return;
    }
    p = q;
  }
  writeln("T");
}
