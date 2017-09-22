import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  writeln(s.lastIndexOf("Z") - s.indexOf("A") + 1);
}
