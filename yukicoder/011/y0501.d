import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], d = rd[1];
  if (d > n) {
    foreach (_; 0..n*2-d) write("A");
    foreach (_; 0..d-n) write("B");
    writeln;
  } else {
    foreach (_; 0..d) write("A");
    foreach (_; 0..n-d) write("C");
    writeln;
  }
}
