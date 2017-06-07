import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto zi = readln.split;

  writeln(zi[$-1], "/", zi[0]);
}
