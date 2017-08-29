import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  const n = 4;
  auto s = new char[][](n);
  foreach (i; 0..n) s[i] = readln.chomp.dup;

  foreach (ref si; s) si.reverse();
  foreach_reverse (si; s) writeln(si);
}
