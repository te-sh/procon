import std.algorithm, std.conv, std.range, std.stdio, std.string;

const ans = ["ABC", "chokudai"];

version(unittest) {} else
void main()
{
  auto q = readln.chomp.to!int;
  writeln(ans[q-1]);
}
