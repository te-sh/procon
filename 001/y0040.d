import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto d = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);

  ai.reverse();
  auto bi = [1, 0, -1, 0];

  while (ai.length >= bi.length) {
    auto ci = ai.take(bi.length);
    ci[] -= bi[] * ci[0];
    ai = ai.drop(1);
  }

  ai = ai.find!"a != 0";
  ai.reverse();

  if (ai.empty) {
    writeln(0);
    writeln(0);
  } else {
    writeln(ai.length - 1);
    writeln(ai.to!(string[]).join(" "));
  }
}
