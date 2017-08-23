import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], m = rd[1];
  auto s = readln.chomp;
  auto t = readln.chomp;
  writeln(levenshteinDistance(s, t));
}
