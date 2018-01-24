import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int x, y; readV(x, y);
  int n; readV(n);
  auto a = readArray!int(n);

  foreach (i; 0..n-1) {
    if (y*a[i] > x*a[i+1]) {
      writeln("NO");
      return;
    }
  }

  writeln("YES");
}
