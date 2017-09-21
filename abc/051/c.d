import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), sx = rd[0], sy = rd[1], tx = rd[2], ty = rd[3];
  auto x = tx - sx, y = ty - sy;

  write('U'.repeat.take(y));
  write('R'.repeat.take(x));
  write('D'.repeat.take(y));
  write('L'.repeat.take(x));
  write("L");
  write('U'.repeat.take(y+1));
  write('R'.repeat.take(x+1));
  write("D");
  write("R");
  write('D'.repeat.take(y+1));
  write('L'.repeat.take(x+1));
  write("U");
  writeln;
}
