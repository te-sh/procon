import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto t = s.split('+');
  writeln(t.count!(ti => !ti.canFind('0')));
}
