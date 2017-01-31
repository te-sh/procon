import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), x = rd[0], y = rd[1], d = rd[2];

  auto r = d + 1;
  if (d == 0) {
    r = 1;
  } else if (x + y < d) {
    r = 0;
  } else {
    if (x < d) r -= d - x;
    if (y < d) r -= d - y;
  }

  writeln(r);
}
