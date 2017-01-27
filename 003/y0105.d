import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto t = readln.chomp.to!size_t;

  foreach (_; t.iota) {
    readln;
    auto xyi = 6.iota.map!(_ => readln.split.to!(real[]));
    auto ai = xyi.map!(xy => atan2(xy[1], xy[0])).map!(a => a * M_1_PI * 180 + 180).array;
    ai.sort();
    auto r = ai.front;
    writefln("%.7f", r >= 50 ? 0 : r);
  }
}
