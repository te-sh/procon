import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ci = readln.split.to!(int[]);

  auto s = ci.sum;
  writeln(ci.count!(c => c * 10 <= s) * 30);
}
