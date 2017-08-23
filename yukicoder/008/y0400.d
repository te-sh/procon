import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp.dup;
  foreach_reverse (c; s) write(c == '<' ? ">" : "<");
  writeln;
}
