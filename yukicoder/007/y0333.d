import std.algorithm, std.conv, std.range, std.stdio, std.string;

const ma = 2 * 10 ^^ 9;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), a = rd[0], b = rd[1];
  if (a > b) {
    writeln(ma - b - 1);
  } else {
    writeln(b - 2);
  }
}
