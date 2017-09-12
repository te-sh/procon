import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto counter = new int[](6);
  foreach (c; s) counter[c - 'A']++;
  writeln(counter.to!(string[]).join(" "));
}
