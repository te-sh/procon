import std.algorithm, std.conv, std.range, std.stdio, std.string;

const auto players = ["oda", "yukiko"];

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto b = 8.iota.map!(_ => readln.chomp).join;

  writeln(players[((s == "oda" ? 0 : 1) + b.count!"a != '.'") % 2]);
}
