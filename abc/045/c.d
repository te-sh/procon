import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto s = readln.chomp, n = s.length;
  auto ans = 0L;

  foreach (i; 0..1<<(n-1)) {
    auto j = [size_t(0)] ~ i.bitsSet.map!"a+1".array ~ [n];
    auto r = 0L;
    foreach (k; 0..j.length-1)
      r += s[j[k]..j[k+1]].to!long;
    ans += r;
  }

  writeln(ans);
}
