import std.algorithm, std.conv, std.range, std.stdio, std.string;

// allowable-error: 10 ** -6

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(real[]), a = rd[0], b = rd[1], x = rd[2], y = rd[3];
  if (x * b < y * a)
    writefln("%.7f", x * (a + b) / a);
  else
    writefln("%.7f", y * (a + b) / b);
}
