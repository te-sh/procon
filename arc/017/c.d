import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], x = rd[1];
  auto w = new int[](n);
  foreach (i; 0..n) w[i] = readln.chomp.to!int;

  if (n == 1) {
    writeln(x == w[0] ? 1 : 0);
    return;
  }

  auto n1 = n/2, n2 = n-n1;

  auto s2 = new int[](1<<n2);
  foreach (i; 0..1<<n2)
    s2[i] = w[n1..$].indexed(i.bitsSet).sum;

  auto s2s = s2.sort();

  auto ans = 0u;
  foreach (i; 0..1<<n1) {
    auto s1 = w.indexed(i.bitsSet).sum;
    ans += s2s.equalRange(x-s1).length;
  }

  writeln(ans);
}
