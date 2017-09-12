import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  void enume(char[] s, size_t r)
  {
    if (r == 0) {
      writeln(s);
      return;
    }

    enume(s~'a', r-1);
    enume(s~'b', r-1);
    enume(s~'c', r-1);
  }

  enume([], n);
}
