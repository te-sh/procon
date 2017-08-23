import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  if (n % 2 != 0) {
    write('7');
    n -= 3;
  }

  writeln('1'.repeat(n / 2));
}
