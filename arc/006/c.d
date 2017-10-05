import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  int[] b;
 loop: foreach (_; 0..n) {
    auto w = readln.chomp.to!int;
    foreach (ref bi; b) {
      if (bi >= w) {
        bi = w;
        continue loop;
      }
    }
    b ~= w;
  }

  writeln(b.length);
}
