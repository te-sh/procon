import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto d = readln.chomp.to!long;

  d *= 108;

  writefln("%d.%02d", d / 100, d % 100);
}
