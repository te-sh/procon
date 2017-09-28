import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = readln.split.to!(int[]);

  auto c = new int[](9);
  foreach (ai; a) ++c[min(8, ai/400)];

  auto r = c[0..8].count!"a>0";
  if (r == 0)
    writeln(1, " ", c[8]);
  else
    writeln(r, " ", r + c[8]);
}
