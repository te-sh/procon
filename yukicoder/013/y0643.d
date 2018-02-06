import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int x, y; readV(x, y);
  writeln(calc(x, y));
}

auto calc(int x, int y)
{
  if (x == y) return 0;
  if (x != 0 && y != 0 && x.abs != y.abs) return -1;
  auto t = [1, 0, 2, 3, 1, 0, 2, 3];
  auto a = (atan2(y.to!real, x.to!real)/PI_4).to!int;
  if (a < 0) a += 8;
  return t[a];
}
