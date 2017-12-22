import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto c = readln.chomp;
  writeln("yukicoder"[c.indexOf('?')]);
}
