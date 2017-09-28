import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), h = rd[0], w = rd[1];

  writeln('#'.repeat.take(w+2));
  foreach (_; 0..h) {
    write("#");
    write(readln.chomp);
    writeln("#");
  }
  writeln('#'.repeat.take(w+2));
}
