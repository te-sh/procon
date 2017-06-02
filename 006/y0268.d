import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto li = readln.split.to!(int[]);
  auto ci = readln.split.to!(int[]);

  li.permutations
    .map!(mi => 2 * (ci[0] * (mi[1] + mi[2]) + ci[1] * (mi[2] + mi[0]) + ci[2] * (mi[0] + mi[1])))
    .minElement
    .writeln;
}
