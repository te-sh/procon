import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.datetime;

version(unittest) {} else
void main()
{
  auto rd = readln.chomp.split('/').to!(int[]), y = rd[0], m = rd[1], d = rd[2];
  auto dat = Date(y, m, d);
  while (dat.year % (dat.month * dat.day) != 0) dat += 1.days;
  writefln("%d/%02d/%02d", dat.year, dat.month, dat.day);
}
