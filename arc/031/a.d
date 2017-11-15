import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp, n = s.length;
  foreach (i; 0..n/2)
    if (s[i] != s[n-1-i]) {
      writeln("NO");
      return;
    }
  writeln("YES");
}
