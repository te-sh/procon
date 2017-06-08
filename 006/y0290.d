import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto s = readln.chomp;

  writeln(calc(n, s) ? "YES" : "NO");
}

auto calc(size_t n, string s)
{
  if (n == 1) return false;

  foreach (i; 1..n)
    if (s[i-1] == s[i]) return true;

  return n >= 4;
}
