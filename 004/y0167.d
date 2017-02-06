import std.algorithm, std.conv, std.range, std.stdio, std.string;

const tbl = [[0,0,0,0], [1,1,1,1], [6,2,4,8], [1,3,9,7], [6,4,6,4],
             [5,5,5,5], [6,6,6,6], [1,7,9,3], [6,8,4,2], [1,9,1,9]];

version(unittest) {} else
void main()
{
  auto n = readln.chomp;
  auto m = readln.chomp;

  if (m == "0") {
    writeln(1);
  } else {
    auto n2 = n.tail(1).to!string.to!int;
    auto m2 = m.tail(2).to!string.to!int % 4;
    writeln(tbl[n2][m2]);
  }
}
