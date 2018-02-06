import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int x1, y1, r; readV(x1, y1, r);
  int x2, y2, x3, y3; readV(x2, y2, x3, y3);

  x2 -= x1; y2 -= y1; x3 -= x1; y3 -= y1;

  writeln(x2 <= -r && x3 >= r && y2 <= -r && y3 >= r ? "NO" : "YES");
  writeln(x2^^2+y2^^2 <= r^^2 && x2^^2+y3^^2 <= r^^2 &&
          x3^^2+y2^^2 <= r^^2 && x3^^2+y3^^2 <= r^^2 ? "NO" : "YES");
}
