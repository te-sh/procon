import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto ai = readln.split.to!(int[]);
  ai.sort();
  auto g = ai.group.map!"a[1]".array;
  g.sort!"a > b";

  if (g.length == 2 && g[0] == 3)
    writeln("FULL HOUSE");
  else if (g.length == 3 && g[0] == 3)
    writeln("THREE CARD");
  else if (g.length == 3 && g[0] == 2 && g[1] == 2)
    writeln("TWO PAIR");
  else if (g.length == 4 && g[0] == 2)
    writeln("ONE PAIR");
  else
    writeln("NO HAND");
}
