import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags
import std.bigint;    // BigInt

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  long r, b; readV(r, b);
  int x, y; readV(x, y);

  auto calc(long s)
  {
    return (r-s)/(x-1) + (b-s)/(y-1) >= s;
  }

  auto bs = iota(min(r, b)+1).map!(s => tuple(s, calc(s))).assumeSorted!"a[1] > b[1]";
  writeln(bs.equalRange(tuple(0L, true)).back[0]);
}
