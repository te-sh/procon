import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  auto m = 100000;
  auto a = ask(0, 0), b = ask(m, 0);
  writeln((a-b+m)/2, " ", (a+b-m)/2); stdout.flush();
}

auto ask(int x, int y)
{
  import core.stdc.stdlib;
  writeln(x, " ", y); stdout.flush();
  int d; readV(d);
  if (d == 0) exit(0);
  return d;
}
