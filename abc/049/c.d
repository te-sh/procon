import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto a = ["dream", "dreamer", "erase", "eraser"];

 loop: while (!s.empty) {
    foreach (ai; a) {
      if (s.length >= ai.length && s[$-ai.length..$] == ai) {
        s = s[0..$-ai.length];
        continue loop;
      }
    }
    writeln("NO");
    return;
  }

  writeln("YES");
}
