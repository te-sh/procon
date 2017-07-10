import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

// allowable-error: 10 ** -4

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto b = readln.chomp.to!real;
  auto a = readln.split.to!(real[]);

  auto rd = real(0), ri = real(0);
  foreach (ai; a) {
    rd += ai * b ^^ (ai - 1);
    ri += ai == -1 ? log(b) : b ^^ (ai + 1) / (ai + 1);
  }

  writefln("%.5f", rd);
  writefln("%.5f", ri);
}
