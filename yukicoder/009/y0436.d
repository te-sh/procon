import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto nc = s.countUntil('w'), nw = s.length - nc;
  writeln(min(nc-1, nw));
}
