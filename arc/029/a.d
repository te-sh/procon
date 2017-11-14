import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto t = new int[](n);
  foreach (i; 0..n) t[i] = readln.chomp.to!int;
  auto s = t.sum;

  auto ans = s;
  foreach (i; 0..1<<n) {
    auto r = t.indexed(i.bitsSet).sum;
    ans = min(ans, max(r, s-r));
  }

  writeln(ans);
}
