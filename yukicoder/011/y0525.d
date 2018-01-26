import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  auto t = readln.chomp;
  auto h = t[0..2].to!int, m = t[3..5].to!int;
  m += 5;
  if (m >= 60) {
    m -= 60;
    h += 1;
  }
  if (h >= 24) {
    h -= 24;
  }
  writefln("%02d:%02d", h, m);
}
