import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], k = rd[1];
  auto a = new int[](n);
  foreach (i; 0..n) a[i] = readln.chomp.to!int;

  auto ans = 0;
  foreach (i; 0..1<<n) {
    auto s = a.indexed(i.bitsSet).sum;
    if (s <= k) ans = max(ans, s);
  }

  writeln(ans);
}
