import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto li = n.iota.map!(_ => readln.split.to!(long[])).map!(rd => rd[0] + rd[1] * 4).array;

  auto maxL = li.fold!max;
  auto di = li.map!(l => maxL - l).array;

  if (di.any!(d => d % 2 == 1))
    writeln(-1);
  else
    writeln(di.sum / 2);
}
