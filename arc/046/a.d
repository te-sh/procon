import std.algorithm, std.conv, std.range, std.stdio, std.string;

T read1(T)(){return readln.chomp.to!T;}

version(unittest) {} else
void main()
{
  auto n = read1!int;
  foreach (i; 0..(n-1)/9+1) write((n-1)%9+1);
  writeln;
}
