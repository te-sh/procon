import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  writeln(s.predSwitch("2 3 ?", "1",
                       "2 ? 3", "14",
                       "3 2 ?", "4",
                       "3 ? 2", "14",
                       "? 2 3", "4",
                       "? 3 2", "1"));
}
