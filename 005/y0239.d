import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto aij = n.iota.map!(_ => readln.split.to!(string[])).array;

  auto ri = aij.transposed.map!(aj => aj.all!(a => a == "nyanpass" || a == "-")).array;
  writeln(ri.count!"a" == 1 ? ri.countUntil!"a" + 1 : -1);
}
