import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  writefln("%02d:%02d:%02d", n/3600, (n%3600)/60, n%60);
}
