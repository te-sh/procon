import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto t = readln.chomp.to!int;
  auto n = readln.chomp.to!size_t;
  auto a = readln.split.to!(int[]);
  auto m = readln.chomp.to!size_t;
  auto b = readln.split.to!(int[]);

  auto c = new int[](101);
  foreach (ai; a) ++c[ai];

  foreach (bi; b) {
    auto s = max(0, bi-t);
    auto i = c[s..bi+1].countUntil!"a > 0";
    if (i == -1) {
      writeln("no");
      return;
    }
    --c[s+i];
  }

  writeln("yes");
}
