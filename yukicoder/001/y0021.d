import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto k = readln.chomp.to!size_t;
  auto ai = n.iota.map!(_ => readln.chomp.to!int).array;

  auto mi = ai.reduce!min;
  auto ma = ai.reduce!max;

  writeln(ma - mi);
}
