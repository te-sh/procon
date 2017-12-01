import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto ee = 0, eo = 0, oe = 0, oo = 0;
  foreach (i; 0..n) {
    auto rd = readln.splitter;
    auto x = rd.front.to!int; rd.popFront();
    auto y = rd.front.to!int;
    if      (!(x&1) && !(y&1)) ++ee;
    else if (!(x&1) &&  (y&1)) ++eo;
    else if ( (x&1) && !(y&1)) ++oe;
    else                       ++oo;
  }
  auto t = ee/2 + eo/2 + oe/2 + oo/2;
  writeln(t&1 ? "Alice" : "Bob");
}
