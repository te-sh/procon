import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto h = new int[](n);
  foreach (i; 0..n) h[i] = readln.chomp.to!int;

  auto ans = 0, s = 0;
  foreach (i; 1..n-1)
    if (h[i-1] > h[i] && h[i] < h[i+1]) {
      ans = max(ans, i-s+1);
      s = i;
    }
  ans = max(ans, n-s);

  writeln(ans);
}
