import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = 9, m = 4;
  auto rd = readln.split, x = rd[0].to!int-1, y = rd[1].to!int-1, w = rd[2];
  auto c = new string[](n);
  foreach (i; 0..n) c[i] = readln.chomp;

  auto dx = 0, dy = 0;
  if (w.canFind('L')) dx = -1;
  if (w.canFind('R')) dx = +1;
  if (w.canFind('U')) dy = -1;
  if (w.canFind('D')) dy = +1;

  foreach (_; 0..m) {
    write(c[y][x]);

    if (x == 0   && dx == -1) dx = +1;
    if (x == n-1 && dx == +1) dx = -1;
    if (y == 0   && dy == -1) dy = +1;
    if (y == n-1 && dy == +1) dy = -1;

    x += dx;
    y += dy;
  }

  writeln;
}
