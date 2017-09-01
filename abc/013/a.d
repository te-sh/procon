import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto x = readln[0];
  writeln(x - 'A' + 1);
}
