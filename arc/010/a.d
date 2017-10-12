import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1], a = rd[2], b = rd[3];

  foreach (i; 0..m) {
    if (n <= a) n += b;
    
    auto c = readln.chomp.to!int;
    if (n < c) {
      writeln(i+1);
      return;
    }

    n -= c;
  }

  writeln("complete");
}
