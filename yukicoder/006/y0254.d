import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

const aba = ["ab", "cd", "ef", "gh", "ij"];

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  auto i = 0;
  while (n > 15) {
    auto k = n.to!real.sqrt.floor.to!int;
    if (aba) {
      foreach (_; 0..k-1) write(aba[i]);
      write(aba[i][0]);
    } else {
      foreach (_; 0..k-1) write(aba[i]);
      write(aba[i][0]);
    }
    n -= k * k;
    ++i;
  }

  writeln("klmnopqrstuvwxy"[0..n]);
}
