import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.dup.representation;
  n.sort!"a > b"();
  writeln(cast(string)n);
}
