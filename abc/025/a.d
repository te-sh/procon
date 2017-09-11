import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp, m = s.length;
  auto n = readln.chomp.to!int;

  string[] g;
  foreach (i; 0..m)
    foreach (j; 0..m)
      g ~= [s[i], s[j]];

  writeln(g[n-1]);
}
