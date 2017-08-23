import std.algorithm, std.conv, std.range, std.stdio, std.string;

// allowable-error: 10 ** -6

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(real[]), xa = rd1[0], ya = rd1[1];
  auto rd2 = readln.split.to!(real[]), xb = rd2[0], yb = rd2[1];

  auto m = (yb - ya) / (xb + xa);
  writefln("%.7f", ya + m * xa);
}
