import std.algorithm, std.conv, std.range, std.stdio, std.string;

T read1(T)(){return readln.chomp.to!T;}
void read2(S,T)(ref S a,ref T b){auto r=readln.splitter;a=r.front.to!S;r.popFront;b=r.front.to!T;}

version(unittest) {} else
void main()
{
  auto n = read1!int;
  int a, b; read2(a, b);

  if (a == b) {
    writeln(n%(a+1) == 0 ? "Aoki" : "Takahashi");
  } else if (a > b) {
    writeln("Takahashi");
  } else {
    writeln(n <= a ? "Takahashi" : "Aoki");
  }
}
