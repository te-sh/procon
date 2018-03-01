import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  long n; readV(n);
  auto bs = iota(1, 2*10L^^9).map!(i => tuple(i, i*(i+1)/2)).assumeSorted!"a[1] < b[1]";
  auto r = bs.equalRange(tuple(0, n));
  if (r.empty) {
    writeln("NO");
  } else {
    writeln("YES");
    writeln(r[0][0]);
  }
}
