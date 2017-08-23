import std.algorithm, std.conv, std.range, std.stdio, std.string;

const rs = ["Won", "Lost", "Drew"];
const rt = [[2, 0, 1], [1, 2, 0], [0, 1, 2]];

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), a = rd[0], b = rd[1];
  writeln(rs[rt[a][b]]);
}
