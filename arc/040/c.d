import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto s = new char[][](n);
  foreach (i; 0..n) s[i] = readln.chomp.dup;

  auto ans = 0;
  foreach (i; 0..n) {
    auto j = s[i].lastIndexOf('.');
    if (j == -1) continue;
    if (i < n-1) s[i+1][j..$][] = 'o';
    ++ans;
  }

  writeln(ans);
}
