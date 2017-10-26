import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto c = 0;
  foreach_reverse (i; 1..10L^^9) {
    auto k = i*2+1;
    auto d = (k^^2-1)/4-1;
    writeln(d);
    ++c;
    if (c == 100000) return;
  }
}
