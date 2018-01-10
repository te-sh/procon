import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = read1!int;
  auto ee = 0, eo = 0, oe = 0, oo = 0;
  foreach (i; 0..n) {
    int x, y; read2(x, y);
    if      (!(x&1) && !(y&1)) ++ee;
    else if (!(x&1) &&  (y&1)) ++eo;
    else if ( (x&1) && !(y&1)) ++oe;
    else                       ++oo;
  }
  auto t = ee/2 + eo/2 + oe/2 + oo/2;
  writeln(t&1 ? "Alice" : "Bob");
}

T read1(T)() { return readln.chomp.to!T; }
void read2(S,T)(ref S a, ref T b) { auto r = readln.splitter; a = r.front.to!S; r.popFront(); b = r.front.to!T; }
