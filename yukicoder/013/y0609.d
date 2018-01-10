import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto n = read1!int;
  auto y = readArray!int(n);
  y.sort();

  auto m = n&1 ? y[n/2] : (y[n/2-1]+y[n/2])/2;
  auto ans = 0L;
  foreach (yi; y) ans += (yi-m).abs;

  writeln(ans);
}

T read1(T)(){return readln.chomp.to!T;}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref ai;a){ai=r.front.to!T;r.popFront;}return a;}
