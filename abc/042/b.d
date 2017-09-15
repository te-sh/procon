import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), n = rd[0], l = rd[1];
  auto s = new string[](n);
  foreach (i; 0..n) s[i] = readln.chomp;
  s.sort();
  foreach (si; s) write(si);
  writeln;
}
