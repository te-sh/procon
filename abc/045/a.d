import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto a = readln.chomp.to!int;
  auto b = readln.chomp.to!int;
  auto h = readln.chomp.to!int;
  writeln((a + b) * h / 2);
}
