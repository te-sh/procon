import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp.split("").map!(c => c == "L" ? 0 : 1);
  writeln(s.fold!((a, b) => a * 2 + b)(1));
}
