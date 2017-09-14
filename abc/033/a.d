import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.map!(c => c - '0').array;
  writeln(n.sort().uniq.array.length == 1 ? "SAME" : "DIFFERENT");
}
