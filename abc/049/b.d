import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), h = rd[0], w = rd[1];
  foreach (_; 0..h) {
    auto c = readln.chomp;
    writeln(c);
    writeln(c);
  }
}
