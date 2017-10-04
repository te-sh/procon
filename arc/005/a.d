import std.algorithm, std.conv, std.range, std.stdio, std.string;

const t = ["TAKAHASHIKUN", "Takahashikun", "takahashikun"];

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto w = readln.split;
  w[$-1] = w[$-1][0..$-1];
  writeln(w.count!(wi => t.canFind(wi)));
}
